class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.present?
  end

  def update?
    user.admin? || user&.author_of?(record)
  end

  def destroy?
    user.admin? || user&.author_of?(record)
  end

  def best_answer?
    user.admin? || user&.author_of?(record&.question)
  end

  def api_update?
    user&.author_of?(record)
  end

  def api_destroy?
    user&.author_of?(record)
  end
end
