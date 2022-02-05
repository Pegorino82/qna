class VotePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def can_vote?
    user.present? && !user.author_of?(record)
  end
end
