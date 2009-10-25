Gem::Specification.new do |s|
  s.name = %q{dm-geokit}
  s.version = "0.10.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt King"]
  s.date = %q{2009-10-25}
  s.description = %q{Adds geographic functionality to DataMapper objects}
  s.email = %q{matt@mattking.org}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "Rakefile", "README", "TODO", "VERSION.yml", "lib/dm-geokit", "lib/dm-geokit/ip_geocode_lookup.rb", "lib/dm-geokit/resource.rb", "lib/dm-geokit.rb", "lib/skeleton", "lib/skeleton/api_keys_template", "lib/jeweler/templates/.gitignore", "lib/dm-geokit/support/distance_measurement.rb", "lib/dm-geokit/support/distance_support.rb", "lib/dm-geokit/support/float.rb", "lib/dm-geokit/support/integer.rb", "lib/dm-geokit/support/symbol.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mattking17/dm-geokit/tree/master}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Adds geographic functionality to DataMapper objects, relying on the Geokit gem for geocoding and searching by geographic location.}

  s.add_dependency(%q<dm-core>, [">= 0.10.1"])
  s.add_dependency(%q<geokit>, [">= 1.5.0"])
  s.add_dependency(%q<dm-aggregates>, [">= 0.10.1"])

end
