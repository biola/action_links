module ActionLinks
  module Helpers
  
    def action_links(object_or_array, options={}, &block)
      list = ActionLinks::List.new(object_or_array, options)

      links = list.links.map { |link|
        unless current_page?(link.url_array) && !link.destroy?
          if permitted_to?(link.action, link.object)
            link_to(link.title, link.url_array, link.html_options)
          end
        end
      }
      
      links << capture(&block) if block_given?
      
      links.compact!
      
      content_tag(list.options[:list_wrapper], :class=>:actions) do
        links.map{ |link|
          content_tag(list.options[:link_wrapper], link, :class=>list.options[:link_wrapper_class])
        }.join("\n").html_safe
      end
    end
    
  end
end
