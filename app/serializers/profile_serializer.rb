class ProfileSerializer < ActiveModel::Serializer
  attributes %i[id email role created_at updated_at]
end
