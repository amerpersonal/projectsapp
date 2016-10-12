json.array!(@projects) do |project|
  json.extract! project, :id, :title, :description, :created_at, :updated_at, :user_id
  json.url project_url(project, format: :json)
end
