# -*- encoding: utf-8 -*-
 
Gem::Specification.new do |s|
  s.name = %q{dm-riak-adapter}
  s.version = "0.0.2"
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mike Richards"]
  s.date = %q{2010-03-23}
  s.description = %q{DataMapper adapter for Riak}
  s.email = %q{mike22e@gmail.com}
  s.files = [
    "README.md",
    "lib/dm-riak-adapter.rb",
    "spec/dm-riak-adapter_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/mikeric/dm-riak-adapter}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{DataMapper adapter for Riak}
  s.test_files = [
    "spec/dm-riak-adapter_spec.rb",
    "spec/spec_helper.rb"
  ]
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
    
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0.10.2"])
      s.add_runtime_dependency(%q<ripple>, [">= 0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0.10.2"])
      s.add_dependency(%q<ripple>, [">= 0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0.10.2"])
    s.add_dependency(%q<ripple>, [">= 0"])
  end
end