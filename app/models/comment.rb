class Comment < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  validates_length_of :text, minimum: 6, maximum: 300
end
