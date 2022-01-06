class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :title, :url, presence: true
end
