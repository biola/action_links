require 'rails'
require 'action_links/list'
require 'action_links/link'
require 'action_links/helpers'

module ActionLinks
  class Railtie < Rails::Railtie
    initializer "action_links.helpers" do
      ActionView::Base.send :include, ActionLinks::Helpers
    end
  end
end
