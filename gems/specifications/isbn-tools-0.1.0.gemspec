Gem::Specification.new do |s|
  s.name = %q{isbn-tools}
  s.version = "0.1.0"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Thierry GODFROID"]
  s.cert_chain = nil
  s.date = %q{2006-09-27}
  s.description = %q{}
  s.email = %q{}
  s.extra_rdoc_files = ["README", "ChangeLog", "LICENCE", "TODO"]
  s.files = ["README", "LICENCE", "TODO", "ChangeLog", "lib/isbn/tools.rb", "data/ranges.dat", "tests/tc_isbn_tools_tests.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://}
  s.rdoc_options = ["--title", "ISBN-Tools", "--main", "README", "--line-numbers"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{isbn-tools}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A series of methods to manipulate ISBN numbers.}
  s.test_files = ["tests/tc_isbn_tools_tests.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 1

    if current_version >= 3 then
    else
    end
  else
  end
end
