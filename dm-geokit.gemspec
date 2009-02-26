# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-geokit}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Foy Savas", "Daniel Higginbotham"]
  s.date = %q{2009-02-26}
  s.description = %q{Simple and opinionated helper for creating Rubygem projects on GitHub}
  s.email = %q{daniel@flyingmachinestudios.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "Rakefile", "README", "TODO", "VERSION.yml", "lib/dm-geokit", "lib/dm-geokit/acts_as_mappable.rb", "lib/dm-geokit/ip_geocode_lookup.rb", "lib/dm-geokit/merbtasks.rb", "lib/dm-geokit/resource.rb", "lib/dm-geokit.rb", "lib/skeleton", "lib/skeleton/api_keys_template", "lib/jeweler/templates/.gitignore"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/flyingmachine/dm-geokit/tree/master}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{DataMapper plugin for geokit stuff forked from Foy Savas's project. Now relies on the geokit gem rather than Foy's gem.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0"])
      s.add_runtime_dependency(%q<andre-geokit>, [">= 0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0"])
      s.add_dependency(%q<andre-geokit>, [">= 0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0"])
    s.add_dependency(%q<andre-geokit>, [">= 0"])
  end
end
