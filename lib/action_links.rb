require 'action_links/version'
require 'action_links/engine' if defined?(Rails)

module ActionLinks
  require 'action_links/configuration'

  def self.configure
    yield config
  end

  def self.config
    @config ||= Configuration.new
  end
end