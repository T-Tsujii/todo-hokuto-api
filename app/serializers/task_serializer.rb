class TaskSerializer < ActiveModel::Serializer
  attributes :id, :body, :is_completed
end
