namespace :geo do
  
  desc "Look up an address using the failover"
  task :multi do
    puts GeoKit::Geocoders::MultiGeocoder.geocode(ENV["ADDR"])
  end
  
  desc "Look up an address on google"
  task :google do
    puts GeoKit::Geocoders::GoogleGeocoder.geocode(ENV["ADDR"])
  end
  
  desc "Look up an address on yahoo"
  task :yahoo do
    puts GeoKit::Geocoders::YahooGeocoder.geocode(ENV["ADDR"])
  end
  
  desc "Look up an address on us_geocoder"
  task :us do
    puts GeoKit::Geocoders::UsGeocoder.geocode(ENV["ADDR"])
  end
  
  desc "Look up an address on ca_geocoder"
  task :ca do
    puts GeoKit::Geocoders::CaGeocoder.geocode(ENV["ADDR"])
  end
  
  desc "Lookup up the address of an IP"
  task :ip do
    puts GeoKit::Geocoders::IpGeocoder.geocode(ENV["ADDR"])
  end
    
end