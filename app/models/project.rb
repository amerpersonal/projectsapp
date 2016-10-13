class Project < ActiveRecord::Base
  	belongs_to :user
  	has_many :tasks

	validate :valid_title, :valid_description

	DESCRIPTION_MAX_LENGTH = 100

	def valid_title
		normalized_title = title.strip
		errors.add(:title, "Title has to be min 10 chars long and have to start with letter") if normalized_title.length < 10 || /[[:digit:]]/.match(normalized_title[0])
	end

	def valid_description
		normalized_description = description.strip
		errors.add(:description, "Description has to have at least 2 words and 10 letters") if normalized_description.length < 10 || description.strip.split(" ").length < 2
	end

	def shorten_description
		return description if description.strip.empty? || description.strip.split(" ").empty?

		short_desc = description.split(" ").each_with_object("") do |word, final_str|
			break final_str if [final_str, " ", word].join.length > DESCRIPTION_MAX_LENGTH || final_str == description
			final_str << " " + word
		end.strip 

		short_desc << "..." if short_desc.length < description.length
		short_desc
	end
end
