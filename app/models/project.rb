class Project < ActiveRecord::Base
  	belongs_to :user
  	has_many :tasks

	validate :valid_title, :valid_description

	MIN_TITLE_LENGTH = 8

	MIN_DESCRIPTION_LENGTH = 10

	DESCRIPTION_MAX_LENGTH = 100

	CATEGORIES = ["general", "front_end", "back_end", "product_design", "database", "data_management"]
	
	def self.all_categories
		CATEGORIES.map { |category| [category.split("_").map { |word| word.camelize}.join(" ") , category] }
	end

	def valid_title
		normalized_title = title.strip
		if normalized_title.length < MIN_TITLE_LENGTH || /[[:digit:]]/.match(normalized_title[0])
			errors.add(:title, "Title has to be min #{MIN_TITLE_LENGTH} chars long and have to start with letter")
		end
	end

	def valid_description
		normalized_description = description.strip
		if normalized_description.length < MIN_DESCRIPTION_LENGTH || description.strip.split(" ").length < 2
			errors.add(:description, "Description has to have at least 2 words and #{MIN_DESCRIPTION_LENGTH} letters")
		end
	end

	def category_name
		category.split("_").map { |word| word.camelize}.join(" ")
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
