module ActionLinks
  class Configuration
    attr_accessor :bootstrap_action_classes
    attr_accessor :bootstrap_action_icons
    attr_accessor :action_icons

    def initialize
      @bootstrap_action_classes = { :show => 'btn', :edit => 'btn', :destroy => 'btn btn-danger' }
      @bootstrap_action_icons = { :show => 'icon-eye-open', :edit => 'icon-pencil', :destroy => 'icon-remove icon-white' }

      @action_icons = { :show => 'eye-open', :edit => 'pencil', :destroy => 'remove' }
    end
  end
end