module TasksHelper

	def change_status_html(task)
		next_status_text = Task::STATUSES.keys[task.new_status_index]

		form_tag task_change_status_path(task), method: :put do
			submit_tag "Move to #{next_status_text}", :class => "btn btn-xs"
		end
	end

	def change_priority_html(task)
		form_tag task_change_priority_path(task), method: :put, :class => "form-inline change-priority-form", :style => "display: inline-block;" do
			select_tag "priority", options_for_select(Task::PRIORITIES, task.priority), :onchange => "javascript:$(this).parent().submit();"
		end
	end

	def task_css_class(task)
		if task.text_status == "Resolved" || task.text_status == "Closed"
			"bg-success"
		else
			task.deadline < Time.now ? "bg-danger" : nil
		end
	end

end
