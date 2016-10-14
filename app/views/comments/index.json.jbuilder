json.array!(@comments) do |comment|
  json.extract! comment, :id, :text, :created_at, :updated_at, :task_id, :user_id
  json.url comment_url(comment, format: :json)
end
