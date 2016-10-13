class Task < ActiveRecord::Base
  	belongs_to :project
	validate :valid_title, :valid_description

	TASK_STATUSES = {
		"Opened" => 1,
		"Started" => 2,
		"Resolved" => 3,
		"Closed" => 4
	}

	TASK_PRIORITIES = [3, 2, 1]

	def valid_title
		normalized_title = title.strip
		errors.add(:title, "Title has to be min 10 chars long and have to start with letter") if normalized_title.length < 10 || /[[:digit:]]/.match(normalized_title[0])
	end

	def valid_description
		normalized_description = description.strip
		errors.add(:description, "Description has to have at least 2 words and 10 letters") if normalized_description.length < 10 || description.strip.split(" ").length < 2
	end

	def text_status
		Hash[Task::statuses.to_a.map { |kv| [kv.last, kv.first] }].with_indifferent_access[status]
	end

	def self.statuses
		TASK_STATUSES
	end

	def self.priorities
		TASK_PRIORITIES
	end

	def new_status_index
		status_index = Task.statuses.values.find_index(status)
		status_index == Task.statuses.length - 1 ? 0 : status_index + 1
	end

	def change_status
		self.status = Task.statuses.values[new_status_index]
	end
end
