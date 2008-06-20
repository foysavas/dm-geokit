module DataMapper
  module GeoKit
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_geographic_location(name, options = {})
        include InstanceMethods

        property name.to_sym, DM::Text
        property "#{name}_lat".to_sym, Float
        property "#{name}_lng".to_sym, Float

        define_method "#{name}" do
          if instance_eval("@#{name}").nil?
            nil
          else
            ::YAML.load(instance_eval("@#{name}"))
          end
        end

        define_method "#{name}=" do |value|
          if value.nil?
            nil
          else value.is_a?(String)
            geo = ::GeoKit::Geocoders::MultiGeocoder.geocode(value)
            attribute_set("#{name}".to_sym, geo.to_yaml)
            attribute_set("#{name}_lat".to_sym, geo.lat)
            attribute_set("#{name}_lng".to_sym, geo.lng)
          end         
        end
      end
    end

    module InstanceMethods

    end

  end
end
