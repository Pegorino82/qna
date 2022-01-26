# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github]

  has_many :questions, class_name: 'Question', foreign_key: 'author_id', dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: 'author_id', dependent: :destroy
  has_many :awards, through: :answers
  has_many :votes, class_name: 'Vote', foreign_key: 'author_id'
  has_many :comments, class_name: 'Comment', foreign_key: 'author_id'

  def author_of?(resource)
    id == resource.author_id
  end
end
