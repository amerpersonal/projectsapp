class Task < ActiveRecord::Base
  	belongs_to :project
	validate :valid_title, :valid_description, :valid_deadline

	include Utils

	STATUSES = {
		"Opened" => 1,
		"Started" => 2,
		"Resolved" => 3,
		"Closed" => 4
	}

	PRIORITIES = [3, 2, 1]

	MIN_DURATION = 30.minutes

	MAX_TITLE_LENGTH = 8

	MAX_DESCRIPTION_LENGTH = 10

	def valid_title
		normalized_title = title.strip
		if normalized_title.length < MAX_TITLE_LENGTH || /[[:digit:]]/.match(normalized_title[0])
			errors.add(:title, "Title has to be min #{MAX_TITLE_LENGTH} chars long and have to start with letter")
		end
	end

	def valid_description
		normalized_description = description.strip
		if normalized_description.length < MAX_DESCRIPTION_LENGTH || description.strip.split(" ").length < 2
			errors.add(:description, "Description has to have at least 2 words and #{MAX_DESCRIPTION_LENGTH} letters")
		end
	end

	def valid_deadline
		if Time.now + MIN_DURATION > self.deadline
			errors.add(:description, "Minimum task duration is  #{DateTime.strptime(MIN_DURATION.to_s, "%s").strftime("%M")} minutes")
		end
	end

	def expired?
		self.deadline < Time.now
	end

	def text_status
		Hash[STATUSES.to_a.map { |kv| [kv.last, kv.first] }].with_indifferent_access[status]
	end

	def new_status_index
		status_index = STATUSES.values.find_index(status)
		status_index == STATUSES.length - 1 ? 0 : status_index + 1
	end

	def change_status
		self.status = STATUSES.values[new_status_index]
	end

	def until_deadline
		timerange_to_readable_string(Time.now, self.deadline)
	end

end
