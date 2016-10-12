module ProjectsHelper

	CATEGORIES = ["general", "front_end", "back_end", "product_design", "database", "data_management"]
	def all_categories
		CATEGORIES.map { |category| [category_id_to_name(category) , category] }
	end

	def category_id_to_name(category)
		category.split("_").map { |word| word.camelize}.join(" ")
	end

end
