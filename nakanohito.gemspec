$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nakanohito/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nakanohito"
  s.version     = Nakanohito::VERSION
  s.authors     = ["Uchio KONDO"]
  s.email       = ["udzura@udzura.jp"]
  s.homepage    = "https://github.com/udzura/nakanohito"
  s.summary     = "Naka-no-hito(a person in the official social account) integration to Rails"
  s.description = "Naka-no-hito(a person in the official social account) integration to Rails, using buffer API"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "buff", ">= 0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "webmock"
end
