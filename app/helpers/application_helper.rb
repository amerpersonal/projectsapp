module ApplicationHelper
    def show_errors(resource)
    	errors = if resource.is_a?(ActionDispatch::Flash::FlashHash)
    		resource.to_hash
    	else
    		resource.errors.messages.select { |field, msg| !msg.empty? }
    	end

    	content_tag :ul do
    		errors.each do |field, msg|
    			next if field == :notice
				formatted_msg = if field == :alert || field == :error
					msg
				else
					[field.to_s.split("_").map { |word| word.camelize }.join(" "), msg].join(" ")
				end
				concat(content_tag :li, formatted_msg, :class => "text-danger")
    		end
    	end
    end

end
