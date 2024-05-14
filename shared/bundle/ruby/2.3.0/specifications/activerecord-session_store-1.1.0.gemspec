# -*- encoding: utf-8 -*-
# stub: activerecord-session_store 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "activerecord-session_store"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Heinemeier Hansson"]
  s.date = "2017-05-11"
  s.email = "david@loudthinking.com"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "https://github.com/rails/activerecord-session_store"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.1.11"
  s.summary = "An Action Dispatch session store backed by an Active Record class."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["< 5.2", ">= 4.0"])
      s.add_runtime_dependency(%q<actionpack>, ["< 5.2", ">= 4.0"])
      s.add_runtime_dependency(%q<railties>, ["< 5.2", ">= 4.0"])
      s.add_runtime_dependency(%q<rack>, ["< 3", ">= 1.5.2"])
      s.add_runtime_dependency(%q<multi_json>, [">= 1.11.2", "~> 1.11"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<appraisal>, ["~> 2.1.0"])
    else
      s.add_dependency(%q<activerecord>, ["< 5.2", ">= 4.0"])
      s.add_dependency(%q<actionpack>, ["< 5.2", ">= 4.0"])
      s.add_dependency(%q<railties>, ["< 5.2", ">= 4.0"])
      s.add_dependency(%q<rack>, ["< 3", ">= 1.5.2"])
      s.add_dependency(%q<multi_json>, [">= 1.11.2", "~> 1.11"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<appraisal>, ["~> 2.1.0"])
    end
  else
    s.add_dependency(%q<activerecord>, ["< 5.2", ">= 4.0"])
    s.add_dependency(%q<actionpack>, ["< 5.2", ">= 4.0"])
    s.add_dependency(%q<railties>, ["< 5.2", ">= 4.0"])
    s.add_dependency(%q<rack>, ["< 3", ">= 1.5.2"])
    s.add_dependency(%q<multi_json>, [">= 1.11.2", "~> 1.11"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<appraisal>, ["~> 2.1.0"])
  end
end
