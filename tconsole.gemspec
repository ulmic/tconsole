# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tconsole/version"

Gem::Specification.new do |s|
  s.name        = "tconsole-rails4"
  s.version     = TConsole::VERSION
  s.authors     = ["Alan Johnson", "Pavel Kalashnikov", "Dmitry Davydov"]
  s.email       = ["kalashnikovisme@gmail.com"]
  s.homepage    = "https://github.com/ulmic/tconsole"
  s.summary     = %q{tconsole is a helpful console for running Rails tests}
  s.description = <<-EOF
    tconsole allows Rails developers to easily and quickly run their tests as a whole or in subsets. It forks the testing processes from
    a preloaded test environment to ensure that developers don't have to reload their entire Rails environment between test runs.
  EOF

  s.rubyforge_project = "tconsole-rails4"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'ansi'
  s.add_runtime_dependency "chattyproc", "~> 1.0.0"
  s.add_runtime_dependency "term-ansicolor", "~> 1.3"
end
