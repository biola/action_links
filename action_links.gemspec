# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "action_links/version"

Gem::Specification.new do |s|
  s.name        = "action_links"
  s.version     = ActionLinks::VERSION
  s.authors     = ["Adam Crownoble", "Ryan Hall"]
  s.email       = ["adam@obledesign.com"]
  s.homepage    = "https://github.com/biola/action_links"
  s.summary     = %q{Quick and painless action links}
  s.description = %q{Automatically includes action links (show, edit, destroy) based on the current page and user roles/permissions}
  s.license     = 'MIT'

  s.rubyforge_project = "action_links"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
