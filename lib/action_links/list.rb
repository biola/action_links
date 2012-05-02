module ActionLinks

  IMPLICIT_ROUTE_ACTIONS = [:show, :destroy]
  
  DEFAULT_OPTIONS = {
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

  class List
    attr_accessor :object_array

    def initialize(object_or_array, options={})
      @object_array = Array(object_or_array)
      self.options = options
    end
    
    def options
      @options ||= []
    end
    
    def options=(options)
      @options = options
      @options.reverse_merge! DEFAULT_OPTIONS
      @options.each { |key,val| @options[key] = Array(val) if DEFAULT_OPTIONS[key].is_a? Array }
      @options[:controller_name] ||= [*namespaces, object.class.model_name.plural].compact.join('/')
    end
    
    def actions
      @actions ||= (options[:actions] - options[:exclude]) + options[:include]
    end
    
    def object
      @object ||= object_array.last
    end
    
    def namespaces
      @namespaces ||= object_array.select{ |obj| obj.is_a? Symbol }
    end
    
    def controller
      @controller ||= "#{options[:controller_name]}_controller".classify.constantize.new
    end
    
    def links
      @links ||= actions.map{ |action|
        if controller.respond_to?(action)
          Link.new(action, object_array, options)
        end
      }.compact
    end
    
    def wrapper_tag(&block)
      content_tag(options[:list_wrapper], :class=>options[:list_wrapper_class]) do
        yield
      end
    end
  end

end
