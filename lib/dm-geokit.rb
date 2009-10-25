%w(rubygems geokit dm-core dm-aggregates).each{|f| require f}
%w(distance_measurement distance_support symbol integer float).each{|f|
  require File.join(File.dirname(__FILE__),'dm-geokit','support',f)
}
require File.join(File.dirname(__FILE__),'dm-geokit','resource')
