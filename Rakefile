begin 
  require 'jeweler' 
  Jeweler::Tasks.new do |s| 
    s.name = 'dm-geokit' 
    s.summary = "DataMapper plugin for geokit"
    s.authors = ["Matt King"]
    s.email = 'matt@mattking.org'
    s.homepage = "http://github.com/mattking17/dm-geokit/tree/master" 
    s.description = "Geographic Property support for DataMapper"
    s.files =  FileList["[A-Z]*", "{bin,generators,lib,test}/**/*", 'lib/jeweler/templates/.gitignore'] 
    s.require_path     = 'lib'
    s.has_rdoc         = true
    s.platform         = Gem::Platform::RUBY
    s.extra_rdoc_files = %w[ README LICENSE TODO ]
    s.add_dependency 'dm-core'
    s.add_dependency 'andre-geokit'
  end 
rescue LoadError 
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com" 
end
