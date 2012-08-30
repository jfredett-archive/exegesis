# -*- encoding: utf-8 -*-
require File.expand_path('../lib/exegesis/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Joe Fredette"]
  gem.email         = ["jfredett@gmail.com"]
  gem.description   = %q{A tool for automatically compiling C projects}
  gem.summary       = %q{Exegesis is a tool for automating many parts of the development of C projects.
                         Following a convention-over-configuration model, it provides tools to create 
                         skeleton projects, as well as providing tools to automate building, testing, and
                         packaging.}
  gem.homepage      = ""

  gem.add_dependency "rake"
  gem.add_dependency "celluloid"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "exegesis"
  gem.require_paths = ["lib"]
  gem.version       = Exegesis::VERSION
end
