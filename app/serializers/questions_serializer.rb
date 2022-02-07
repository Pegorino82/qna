class QuestionsSerializer < ActiveModel::Serializer
  attributes %i[id title short_title body best_answer_id created_at updated_at]
  has_many :answers, serializer: AnswersSerializer
  belongs_to :author, class_name: 'User'

  def short_title
    object.title.truncate(7)
  end
end
