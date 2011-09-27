require "action_links/version"

module ActionLinks
  require 'action_links/engine' if defined?(Rails)
  
  # for easy configuration
  def self.config
    yield self
  end
  
  
  # A helper that renders the action links. 
  # Automatically renders :show, :edit, and :destroy if user has permissions to those actions
  #
  #   <%= action_links @articles %>
  #
  def action_links(object_or_array, options={}, &block)
    implicit_route_actions = [:show, :destroy]
  
    # TODO: move default actions into a config file
    defaults = {
      :actions => [:show, :edit, :destroy],
      :include => [],
      :exclude => [],
      :controller_name => nil,
      :remote => [],
      :list_wrapper => :ul,
      :list_wrapper_class => :actions,
      :link_wrapper => :li,
      :link_wrapper_class => nil
    }
    
    options.reverse_merge! defaults
    options.each { |key,val| options[key] = Array(val) if defaults[key].is_a? Array }
    actions = (options[:actions] - options[:exclude]) + options[:include]
    links = []
    
    object_array = Array(object_or_array)
    object = object_array.last
    object_name = object.class.model_name.human
    namespaces = object_array.select{ |obj| obj.is_a? Symbol }
    options[:controller_name] ||= [*namespaces, object.class.model_name.plural].compact.join('/')
    controller = "#{options[:controller_name]}_controller".classify.constantize.new

    links = actions.map do |action|
      permission_passed = false
      if respond_to? :permitted_to?
        permission_passed = permitted_to?(action, object)
      else
        permission_passed = true
      end
      if controller.respond_to?(action) && permission_passed
        url_array = implicit_route_actions.include?(action) ? object_array : [action, *object_array]
        unless current_page?(url_array) && action != :destroy
          title = I18n.t(action, :scope=>'action_links', :default=>action.to_s.humanize)
          html_options = { :class=>action.to_s.parameterize, :title=>"#{title} #{object_name}" }
          html_options[:remote] = true if options[:remote].include? action
          
          if action == :destroy
            html_options.merge! :method=>:delete, :confirm=>I18n.t(:confirm_delete, :scope=>'action_links', :default=>'Are you sure?')
          end
          
          link_to(title, url_array, html_options)
        end
      end
    end

    links << capture(&block) if block_given?

    return content_tag(options[:list_wrapper], :class=>:actions) do
      links.compact.map { |link|
        content_tag(options[:link_wrapper], link, :class=>options[:link_wrapper_class])
      }.join("\n").html_safe
    end
  end
  
  ActionView::Base.send :include, ActionLinks
end
