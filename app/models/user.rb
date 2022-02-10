# frozen_string_literal: true

class User < ApplicationRecord
  enum role: %i[user admin], _default: 'user'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :questions, class_name: 'Question', foreign_key: 'author_id', dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: 'author_id', dependent: :destroy
  has_many :awards, through: :answers
  has_many :votes, class_name: 'Vote', foreign_key: 'author_id'
  has_many :comments, class_name: 'Comment', foreign_key: 'author_id'
  has_many :authorizations, dependent: :destroy
  has_many :followings, class_name: 'Following', foreign_key: 'author_id', dependent: :destroy

  def author_of?(resource)
    id == resource.author_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def email_confirmed?(auth)
    authorizations.find_by(uid: auth.uid, provider: auth.provider)&.confirmed?
  end
end
