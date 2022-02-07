class AnswersSerializer < ActiveModel::Serializer
  attributes %i[id body author_id question_id created_at updated_at]
end
