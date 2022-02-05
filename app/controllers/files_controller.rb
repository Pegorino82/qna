# frozen_string_literal: true

class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    authorize @file.record, policy_class: FilePolicy
    @file.purge
  end
end
