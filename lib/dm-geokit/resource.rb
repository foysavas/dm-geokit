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

        property name.to_sym, String, :length => 255
        property "#{name}_distance".to_sym, Float

        PROPERTY_NAMES.each do |p|
          if p.match(/l(at|ng)/)
            property "#{name}_#{p}".to_sym, Float, :precision => 15, :scale => 12, :index => true
          else
            property "#{name}_#{p}".to_sym, String, :length => 255
          end
        end

        DataMapper.auto_upgrade!

        if options[:auto_geocode] == true or options[:auto_geocode].nil?
          define_method :auto_geocode? do
            true
          end
        else
          define_method :auto_geocode? do
            false
          end
        end

        define_method "#{name}" do
          if attribute_get(name.to_sym).nil?
            nil
          else
            GeographicLocation.new(name, self)
          end
        end

        define_method "#{name}=" do |value|
          if value.nil?
            nil
          elsif value.is_a?(String)
            if auto_geocode?
              geo = ::GeoKit::Geocoders::MultiGeocoder.geocode(value)
              if geo.success?
                attribute_set(name.to_sym, geo.full_address)
                PROPERTY_NAMES.each do |p|
                  attribute_set("#{name}_#{p}".to_sym, geo.send(p.to_sym))
                end
              end
            else
              attribute_set(name.to_sym, value)
            end
          end
        end
      end
      alias acts_as_mappable has_geographic_location
    end

    module InstanceMethods
      def self.included(base) # :nodoc:
        base.extend SingletonMethods
      end
      
      module SingletonMethods # :nodoc:
        def all(query = {})
          super(prepare_query(query))
        end

        def first(query = {})
          super(prepare_query(query))
        end

        # Required dm-aggregates to work
        def count(query = {})
          super(prepare_query(query))
        end

        private

        # Looks in the query for keys that are a DistanceOperator, then extracts the keys/values and turns them into conditions
        def prepare_query(query)
          query.each_pair do |k,v|
            next if not k.is_a?(DistanceOperator)
            field = k.target
            origin = v[:origin].is_a?(String) ? ::GeoKit::Geocoders::MultiGeocoder.geocode(v[:origin]) : v[:origin]
            distance = v[:distance]
            query[:conditions] = expand_conditions(query[:conditions], "#{sphere_distance_sql(field, origin, distance.measurement)}", distance.to_f)
            query[:conditions] = apply_bounds_conditions(query[:conditions], field, bounds_from_distance(distance.to_f, origin, distance.measurement))
            query[:fields] = expand_fields(query[:fields], field, "#{sphere_distance_sql(field, origin, distance.measurement)}")
            query.delete(k)
          end
          query
        end

        # Spherical distance sql
        def sphere_distance_sql(field, origin, units)
          lat = deg2rad(origin.lat)
          lng = deg2rad(origin.lng)
          qualified_lat_column = "`#{storage_name}`.`#{field}_lat`"
          qualified_lng_column = "`#{storage_name}`.`#{field}_lng`"
          "(ACOS(least(1,COS(#{lat})*COS(#{lng})*COS(RADIANS(#{qualified_lat_column}))*COS(RADIANS(#{qualified_lng_column}))+COS(#{lat})*SIN(#{lng})*COS(RADIANS(#{qualified_lat_column}))*SIN(RADIANS(#{qualified_lng_column}))+SIN(#{lat})*SIN(RADIANS(#{qualified_lat_column}))))*#{units_sphere_multiplier(units)})"
        end

        # in case conditions were altered by other means
        def expand_conditions(conditions, sql, value)
          if conditions.is_a?(Hash)
            [conditions.keys.inject(''){|m,k|
              m << "#{k} = ?"
            } << " AND #{sql} <= ?"] + ([conditions.values] << value)
          elsif conditions.is_a?(Array)
            if conditions.size == 1
              ["#{conditions[0]} AND #{sql} <= ?", value]
            else
              conditions[0] = "#{conditions[0]} AND #{sql} <= ?"
              conditions << value
              conditions
            end
          else
            ["#{sql} <= ?", value]
          end
        end

        # Hack in the distance field by adding the :fields option to the query
        def expand_fields(fields, distance_field, sql)
          f = DataMapper::Property::Distance.new(self, "#{distance_field}_distance".to_sym, :field => "#{sql} as #{distance_field}_distance")
          if fields.is_a?(Array) # user specified fields, just tack this onto the end
            [f] + fields
          else # otherwise since we specify :fields, we have to add back in the original fields it would have selected
            [f] + self.properties(repository.name).defaults
          end
        end

        def bounds_from_distance(distance, origin, units)
          if distance
            ::GeoKit::Bounds.from_point_and_radius(origin,distance,:units=>units)
          else 
            nil
          end
        end

        def apply_bounds_conditions(conditions, field, bounds)
          qualified_lat_column = "`#{storage_name}`.`#{field}_lat`"
          qualified_lng_column = "`#{storage_name}`.`#{field}_lng`"
          sw, ne = bounds.sw, bounds.ne
          lng_sql = bounds.crosses_meridian? ? "(#{qualified_lng_column}<=#{sw.lng} OR #{qualified_lng_column}>=#{ne.lng})" : "#{qualified_lng_column}>=#{sw.lng} AND #{qualified_lng_column}<=#{ne.lng}"
          bounds_sql = "#{qualified_lat_column}>=#{sw.lat} AND #{qualified_lat_column}<=#{ne.lat} AND #{lng_sql}"
          conditions[0] << " AND (#{bounds_sql})"
          conditions
        end

      end
    end

    class GeographicLocation
      attr_accessor :full_address, :lat, :lng, :street_address, :city, :state, :zip, :country_code, :distance
      def initialize(field, obj)
        PROPERTY_NAMES.each do |p|
          instance_variable_set("@#{p}",obj.send("#{field}_#{p}"))
        end
        @distance = obj.send("#{field}_distance") if obj.respond_to?("#{field}_distance".to_sym)
      end
      def to_s
        @full_address
      end
      def to_lat_lng
        ::GeoKit::LatLng.new(@lat,@lng)
      end
    end

    class DistanceOperator < DataMapper::Query::Operator
    end

    module DataObjectsAdapter
      extend Chainable
      chainable do
        def property_to_column_name(property, qualify)
          if property.is_a?(DataMapper::Property::Distance)
            property.options[:field]
          else
            super(property, qualify)
          end
        end
      end
    end
  end

  module Adapters
    extendable do
      # TODO: document
      # @api private
      def const_added(const_name)
        if DataMapper::GeoKit.const_defined?(const_name)
          adapter = const_get(const_name)
          adapter.send(:include, DataMapper::GeoKit.const_get(const_name))
        end
        super
      end
    end
  end

  class Property
    class Distance < Float
      
    end
  end

end
