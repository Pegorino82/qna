# frozen_string_literal: true

class Award < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true

  has_one_attached :image

  validates :title, :image, presence: true
  validate :image_validation

  private

  def image_validation
    return errors.add :image, I18n.t('awards.errors.not_blank') unless image.attached?

    errors.add :image, I18n.t('awards.errors.not_image') unless image.blob.content_type.start_with?('image/')
  end
end
