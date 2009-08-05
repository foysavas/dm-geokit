module DataMapper
  module GeoKit
    PROPERTY_NAMES = %w(lat lng street_address city state zip country_code full_address)

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_geographic_location(name, options = {})
        return if self.included_modules.include?(DataMapper::GeoKit::InstanceMethods)
        send :include, InstanceMethods
        send :include, ::GeoKit::Mappable

        property name.to_sym, String, :size => 255
        PROPERTY_NAMES.each do |p|
          if p.match(/l(at|ng)/)
            property "#{name}_#{p}".to_sym, Float, :precision => 15, :scale => 12, :index => true
          else
            property "#{name}_#{p}".to_sym, String, :size => 255
          end
        end

        DataMapper.auto_upgrade!

        define_method "#{name}" do
          if(value = attribute_get(name.to_sym)).nil?
            nil
          else
            GeographicLocation.new(name, self)
          end
        end

        define_method "#{name}=" do |value|
          if value.nil?
            nil
          else value.is_a?(String)
            geo = ::GeoKit::Geocoders::MultiGeocoder.geocode(value)
            if geo.success?
              attribute_set(name.to_sym, geo.full_address)
              PROPERTY_NAMES.each do |p|
                attribute_set("#{name}_#{p}".to_sym, geo.send(p.to_sym))
              end
            end         
          end
        end

        cattr_accessor :distance_column_name, :default_units, :default_formula, :lat_column_name, :lng_column_name, :qualified_lat_column_name, :qualified_lng_column_name
        self.distance_column_name = options[:distance_column_name]  || 'distance'
        self.default_units = options[:default_units] || ::GeoKit::default_units
        self.default_formula = options[:default_formula] || ::GeoKit::default_formula
        self.lat_column_name = "#{name}_lat"
        self.lng_column_name = "#{name}_lng"
        self.qualified_lat_column_name = "#{storage_name}.#{lat_column_name}"
        self.qualified_lng_column_name = "#{storage_name}.#{lng_column_name}"
        if options.include?(:auto_geocode) && options[:auto_geocode]
          # if the form auto_geocode=>true is used, let the defaults take over by suppling an empty hash
          options[:auto_geocode] = {} if options[:auto_geocode] == true 
          cattr_accessor :auto_geocode_field, :auto_geocode_error_message
          self.auto_geocode_field = options[:auto_geocode][:field] || 'address'
          self.auto_geocode_error_message = options[:auto_geocode][:error_message] || 'could not locate address'
          
          # set the actual callback here
#           before_validation_on_create :auto_geocode_address
        end

      end
      alias acts_as_mappable has_geographic_location
    end

    module InstanceMethods
      # Mix class methods into module.
      def self.included(base) # :nodoc:
        base.extend SingletonMethods
      end
      
      # Class singleton methods to mix into ActiveRecord.
      module SingletonMethods # :nodoc:
        # Extends the existing find method in potentially two ways:
        # - If a mappable instance exists in the options, adds a distance column.
        # - If a mappable instance exists in the options and the distance column exists in the
        #   conditions, substitutes the distance sql for the distance column -- this saves
        #   having to write the gory SQL.
        def all(query = {})
          super(prepare_query(query))
        end

        private

        # Looks in the query for keys that are a DistanceOperator, then extracts the keys/values and turns then into conditions
        def prepare_query(query)
          query.keys.inject({}){|m,k| m.merge!(k => query.delete(k)) if k.is_a?(DistanceOperator)}.each_pair do |k,v|
            field = k.field
            origin = v[:origin].is_a?(String) ? ::GeoKit::Geocoders::MultiGeocoder.geocode(v[:origin]) : v[:origin]
            distance = v[:distance]
            query[:conditions] = ["#{sphere_distance_sql(field, origin, distance.measurement)} < ?", distance.to_f]
          end
          query
        end

        # Returns the distance SQL using the spherical world formula (Haversine).  The SQL is tuned
        # to the database in use.
        def sphere_distance_sql(field, origin, units)
          lat = deg2rad(origin.lat)
          lng = deg2rad(origin.lng)
          qualified_lat_column = "`#{storage_name}`.`#{field}_lat`"
          qualified_lng_column = "`#{storage_name}`.`#{field}_lng`"
          sql=<<-SQL_END 
                  (ACOS(least(1,COS(#{lat})*COS(#{lng})*COS(RADIANS(#{qualified_lat_column}))*COS(RADIANS(#{qualified_lng_column}))+
                  COS(#{lat})*SIN(#{lng})*COS(RADIANS(#{qualified_lat_column}))*SIN(RADIANS(#{qualified_lng_column}))+
                  SIN(#{lat})*SIN(RADIANS(#{qualified_lat_column}))))*#{units_sphere_multiplier(units)})
                  SQL_END
          sql
        end

      end
    end

    class GeographicLocation
      attr_accessor :full_address, :lat, :lng, :street_address, :city, :state, :zip, :country_code
      def initialize(field, obj)
        PROPERTY_NAMES.each do |p|
          instance_variable_set("@#{p}",obj.send("#{field}_#{p}"))
        end
      end
      def to_s
        @full_address
      end
    end

    class DistanceOperator
      attr_accessor :field, :type
      def initialize(field,type)
        @field = field
        @type = type
      end
    end

  end
end
