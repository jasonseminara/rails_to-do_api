class TaskSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :description,
    :deleted,
    :completed,
    :created_at,
    :updated_at
end
