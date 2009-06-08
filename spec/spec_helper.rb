$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')
%w(dm-geokit).each{|l| require l}

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, "mysql://root@localhost/dm_geokit_test")

class Location
  include DataMapper::Resource
  include DataMapper::GeoKit
  property :id, Serial
  has_geographic_location :address
end

class UninitializedLocation
  include DataMapper::Resource
  include DataMapper::GeoKit
  property :id, Serial
end

DataMapper.auto_migrate!

