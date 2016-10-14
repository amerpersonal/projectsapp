module ApplicationHelper
    def show_errors(resource)
    	content_tag :ul do
    		resource.errors.messages.each do |field, msg|
    			unless msg.empty?
    				formatted_msg = [field.to_s.split("_").map { |word| word.camelize }.join(" "), msg].join(" ")
    				puts "xxx #{formatted_msg}"
    				concat(content_tag :li, formatted_msg, :class => "text-danger")
    			end
    		end
    	end
    end

end
