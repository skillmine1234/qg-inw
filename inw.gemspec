$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "inw/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "inw"
  s.version     = Inw::VERSION
  s.authors     = ["pawan bora"]
  s.email       = ["pawansinghbora4@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Inw."
  s.description = "TODO: Description of Inw."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.2"

  s.add_development_dependency "sqlite3"
end
