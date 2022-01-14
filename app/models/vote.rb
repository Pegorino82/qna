class Vote < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validate :author_validation

  def like
    self.update(value: 1) if self.value == 0
    self.update(value: 0) if self.value == -1
  end

  def dislike
    self.update(value: -1) if self.value == 0
    self.update(value: 0) if self.value == 1
  end

  private

  def author_validation
    errors.add :user, "Can't vote your #{votable.class.name}" if author&.author_of?(votable)
  end
end
