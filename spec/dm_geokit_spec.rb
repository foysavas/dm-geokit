require File.dirname(__FILE__) + '/spec_helper'

describe "dm-geokit" do
  it "should add address fields after calling has_geographic_location" do
    u = UninitializedLocation.new
    u.should_not respond_to(:address)
    DataMapper::GeoKit::PROPERTY_NAMES.each do |p|
      u.should_not respond_to("address_#{p}".to_sym)
    end
    UninitializedLocation.send(:has_geographic_location, :address)
    u = UninitializedLocation.new
    u.should respond_to(:address)
    DataMapper::GeoKit::PROPERTY_NAMES.each do |p|
      u.should respond_to("address_#{p}".to_sym)
    end
  end

  it "should respond to acts_as_mappable" do
    Location.should respond_to(:acts_as_mappable)
  end

  it "should have a geocode method" do
    Location.should respond_to(:geocode)    
  end

  it "should have the address field return a GeographicLocation object" do
    l = Location.create(:address => "5119 NE 27th ave portland, or 97211")
    l.address.should be_a(DataMapper::GeoKit::GeographicLocation)
    DataMapper::GeoKit::PROPERTY_NAMES.each do |p|
      l.address.should respond_to("#{p}".to_sym)
    end
  end

  it "should set address fields on geocode" do
    l = Location.new
    l.address.should be(nil)
    DataMapper::GeoKit::PROPERTY_NAMES.each do |p|
      l.send("address_#{p}").should be(nil)
    end
    l.address = '5119 NE 27th ave portland, or 97211'
    DataMapper::GeoKit::PROPERTY_NAMES.each do |p|
      l.send("address_#{p}").should_not be(nil)
    end
  end

  it "should convert to LatLng" do
    l = Location.create(:address => "5119 NE 27th ave portland, or 97211")
    l.address.should respond_to(:to_lat_lng)
    l.address.to_lat_lng.should be_a(::GeoKit::LatLng)
    l.address.to_lat_lng.lat.should == l.address.lat
    l.address.to_lat_lng.lng.should == l.address.lng
  end

  it "should find a location with LatLng Object" do
    Location.all(:address.near => {:origin => ::GeoKit::LatLng.new(45.5767359,-122.670399), :distance => 3.mi}).size.should == 2
  end

  it "should find a location with a String" do
    Location.all(:address.near => {:origin => 'portland, or', :distance => 3.mi}).size.should == 2
  end

  it "should find a location with LatLng Object in KM" do
    Location.all(:address.near => {:origin => ::GeoKit::LatLng.new(45.5767359,-122.670399), :distance => 4.km}).size.should == 2
  end

  it "should find a location with a String in KM" do
    Location.all(:address.near => {:origin => 'portland, or', :distance => 5.km}).size.should == 2
  end

end
