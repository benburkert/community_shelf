Gem::Specification.new do |s|
  s.name = %q{dm-is-permalink}
  s.version = "0.9.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Smith"]
  s.date = %q{2008-08-31}
  s.description = %q{DataMapper plugin for adding a permalink to a model}
  s.email = ["wbsmith83@gmail.com"]
  s.extra_rdoc_files = ["README.txt", "LICENSE", "TODO"]
  s.files = ["History.txt", "LICENSE", "Manifest.txt", "README.txt", "Rakefile", "TODO", "lib/dm-is-permalink.rb", "lib/dm-is-permalink/is/permalink.rb", "lib/dm-is-permalink/is/version.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/sam/dm-more/tree/master/dm-is-permalink}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dm-is-permalink}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{DataMapper plugin for adding a permalink to a model}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<dm-core>, [">= 0.9.5"])
      s.add_development_dependency(%q<hoe>, [">= 1.7.0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0.9.5"])
      s.add_dependency(%q<hoe>, [">= 1.7.0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0.9.5"])
    s.add_dependency(%q<hoe>, [">= 1.7.0"])
  end
end
