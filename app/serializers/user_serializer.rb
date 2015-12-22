class UserSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :username, :created_at, :updated_at
end
