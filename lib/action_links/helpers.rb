module ActionLinks
  module Helpers
    def action_links(object_or_array, options = {}, &block)
      list = ActionLinks::List.new(object_or_array, options)

      links = list.links.map { |link|
        if allowed_to_visit?(link) && !already_at?(link)
          link_to(link.title, link.url_array, link.html_options)
        end
      }
      
      links << capture(&block) if block_given?
      
      links.compact!
      
      content_tag(list.options[:list_wrapper], :class=>list.options[:list_wrapper_class]) do
        links.map{ |link|
          content_tag(list.options[:link_wrapper], link, :class=>list.options[:link_wrapper_class])
        }.join("\n").html_safe
      end
    end

    def action_link(action, object_or_array, options = {})
      link = ActionLinks::Link.new(action, object_or_array, options)
      
      link_url_or_array = options[:url] || link.url_array

      if allowed_to_visit?(link) && (!current_page?(link_url_or_array) || link.destroy?) # Check user permissions on action
        title = link.icon ? content_tag(:i, '', :class => "icon-#{link.icon}") + " " + link.title : link.title # append icon to title if it exists  

        html_link = link_to(title, link_url_or_array, link.html_options) 

        if options[:link_wrapper]
          content_tag(options[:link_wrapper], html_link, :class=>options[:link_wrapper_class])
        else
          html_link  # Return plain link if wrapper is not specified
        end
      end
    end

    def action_link_builder(object_or_array, options = {}, &block)
      ActionLinks::List.new(object_or_array, options).links.each do |link|
        if allowed_to_visit?(link) && !already_at?(link)
          yield(link)
        end
      end

      nil
    end

    def bootstrap_action_links(object_or_array, options = {}, &block)
      css_classes = options[:bootstrap_action_classes] || ActionLinks.config.bootstrap_action_classes
      icons = options[:bootstrap_action_icons] || ActionLinks.config.bootstrap_action_icons

      links = []

      ActionLinks::List.new(object_or_array, options).links.each do |link|
        if allowed_to_visit?(link) && !already_at?(link)
          links << link_to(link.url_array, link.html_options.merge(:class => css_classes[link.action])) do
            link_content = [content_tag(:span, link.title, :class => :title)]
            link_content.unshift(content_tag(:i, '', :class => icons[link.action])) if icons[link.action]
            link_content.join(' ').html_safe
          end
        end
      end

      links << capture(&block) if block_given?
      
      links.join("\n").html_safe
    end

    private

    def already_at?(link)
      current_page?(link.url_array) && !link.destroy?
    end

    def allowed_to_visit?(link)
      permitted_to?(link.action, link.object)
    end
  end
end
