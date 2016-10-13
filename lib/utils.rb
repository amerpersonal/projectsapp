module Utils
	def timerange_to_readable_string(from, to)
		diff = (from - to).abs.to_i

		number_of_days = diff / 86400
		diff = diff % 86400
		number_of_hours = diff / 3600
		diff = diff % 3600
		number_of_minutes = diff / 60

		str = ""
		str << "#{number_of_days} days " if number_of_days > 0
		str << "#{number_of_hours} hours " if number_of_hours > 0
		str << "#{number_of_minutes} mins" if number_of_minutes > 0
		str = from < to ? "in " << str : str  << " ago"
	end
end