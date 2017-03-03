# -*- encoding: utf-8 -*-
# stub: ${artifactId} ${version} ruby lib

Gem::Specification.new do |s|
  s.name = "${artifactId}"
  s.version = "${version}"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.description = "${name}"
  s.homepage = "https://github.com/asciidoctor/asciidoctor-extensions-lab"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "${description}"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<asciidoctor>, ["~> 1.5.0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<asciidoctor>, ["~> 1.5.0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<asciidoctor>, ["~> 1.5.0"])
  end
end
