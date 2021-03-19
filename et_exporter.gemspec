$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "et_exporter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "et_exporter"
  spec.version     = EtExporter::VERSION
  spec.authors     = ["Gary Taylor"]
  spec.email       = ["gary.taylor@hmcts.net"]
  spec.homepage    = "https://github.com/hmcts/et_exporter_gem"
  spec.summary     = "Exports employment tribunals data to queues in sidekiq specific to the external system"
  spec.description = "Exports employment tribunals data to queues in sidekiq specific to the external system"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.2.3"
  spec.add_dependency 'jbuilder', '~> 2.9', '>= 2.9.1'
  
  spec.add_dependency "pg"
  spec.add_development_dependency 'rspec-rails', '>= 3.8.2', '~> 5.0'
  spec.add_development_dependency 'sqlite3', '~> 1.4', '>= 1.4.1'
  spec.add_development_dependency 'factory_bot_rails', '~> 5.0', '>= 5.0.2'
  spec.add_development_dependency 'json_matchers', '~> 0.11.0'
  spec.add_dependency 'sidekiq', '>= 5.2.7'
end
