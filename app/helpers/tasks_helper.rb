module TasksHelper

	def change_status_html(task)
		next_status_text = Task.statuses.keys[task.new_status_index]

		form_tag task_change_status_path(task), method: :put do
			submit_tag "Move to #{next_status_text}", :class => "btn btn-xs"
		end
	end

	def change_priority_html(task)
		form_tag task_change_priority_path(task), method: :put, :class => "form-inline", :style => "display: inline-block;" do
			select_tag "priority", options_for_select(Task.priorities, task.priority)
		end
	end

end
