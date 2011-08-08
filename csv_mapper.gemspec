# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "csv_mapper/version"

Gem::Specification.new do |s|
  s.name        = "csv_mapper"
  s.version     = CsvMapper::VERSION
  s.authors     = ["Marc"]
  s.email       = ["marc@magiclabs.de"]
  s.homepage    = "magiclabs.de"
  s.summary     = %q{Provides a controller action and views for uploading, mapping and importing data from a csv}

  s.rubyforge_project = "csv_mapper"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("fastercsv")
end
