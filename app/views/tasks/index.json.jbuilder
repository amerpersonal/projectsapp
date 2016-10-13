json.array!(@tasks) do |task|
  json.extract! task, :id, :title, :description, :status, :deadline, :priority, :created_at, :updated_at, :project_id
  json.url task_url(task, format: :json)
end
