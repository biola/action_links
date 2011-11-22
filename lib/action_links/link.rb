module ActionLinks
  class Link
    attr_accessor :action
    attr_accessor :object_array
    attr_accessor :options
  
    def initialize(action, object_array, options={})
      @action = action.to_s.to_sym
      @object_array = Array(object_array)
      @options = options
    end
    
    def object
      @object ||= object_array.last
    end
    
    def object_name
      @object_name ||= object.class.model_name.human
    end
    
    def title
      @title ||= I18n.t(action, :scope=>'action_links', :default=>action.to_s.humanize)
    end
    
    def url_array
      @url_array ||= IMPLICIT_ROUTE_ACTIONS.include?(action) ? object_array : [action, *object_array]
    end
    
    def show?
      action == :show
    end
    
    def edit?
      action == :edit
    end
    
    def destroy?
      action == :destroy
    end
    
    def remote?
      options[:remote].include? action
    end
    
    def html_options
      return @html_options unless @html_options.nil?
      
      @html_options = { :class=>action.to_s.parameterize, :title=>"#{title} #{object_name}" }
      @html_options[:remote] = true if remote?
      
      if action == :destroy
        @html_options.merge! :method=>:delete, :confirm=>I18n.t(:confirm_delete, :scope=>'action_links', :default=>'Are you sure?')
      end

      @html_options
    end
    
    def wrapper_tag(&block)
      content_tag(options[:link_wrapper], :class=>options[:link_wrapper_class]) do
        yield
      end
    end
  end
end
