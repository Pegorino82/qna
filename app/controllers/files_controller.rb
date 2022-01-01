# frozen_string_literal: true

class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge if current_user.author_of?(@file.record)
  end
end
