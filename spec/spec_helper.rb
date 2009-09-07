$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')
%w(dm-geokit dm-aggregates).each{|l| require l}

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, "mysql://root@localhost/dm_geokit_test")

class Location
  include DataMapper::Resource
  include DataMapper::GeoKit
  property :id, Serial
  has_geographic_location :address
  has n, :comments
end

class Comment
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :location_id, Integer
  belongs_to :location
end

class UninitializedLocation
  include DataMapper::Resource
  include DataMapper::GeoKit
  property :id, Serial
end

DataMapper.auto_migrate!

