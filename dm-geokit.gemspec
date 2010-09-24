Gem::Specification.new do |s|
  s.name = %q{dm-geokit}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt King"]
  s.date = %q{2010-09-23}
  s.description = %q{Geographic Property support for DataMapper}
  s.email = %q{mking@mking.me}
  s.extra_rdoc_files = [
    "LICENSE",
     "README",
     "TODO"
  ]
  s.files = [
    "LICENSE",
     "README",
     "Rakefile",
     "TODO",
     "VERSION.yml",
     "lib/dm-geokit.rb",
     "lib/dm-geokit/acts_as_mappable.rb",
     "lib/dm-geokit/ip_geocode_lookup.rb",
     "lib/dm-geokit/merbtasks.rb",
     "lib/dm-geokit/resource.rb",
     "lib/dm-geokit/support/distance_measurement.rb",
     "lib/dm-geokit/support/distance_support.rb",
     "lib/dm-geokit/support/float.rb",
     "lib/dm-geokit/support/integer.rb",
     "lib/dm-geokit/support/symbol.rb",
     "lib/jeweler/templates/.gitignore",
     "lib/skeleton/api_keys_template"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mattking17/dm-geokit/tree/master}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dm-geokit}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{DataMapper plugin for geokit}
  s.test_files = [
    "spec/dm_geokit_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["= 0.10.2"])
      s.add_runtime_dependency(%q<geokit>, [">= 0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0"])
      s.add_dependency(%q<andre-geokit>, [">= 0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0"])
    s.add_dependency(%q<andre-geokit>, [">= 0"])
  end
end
