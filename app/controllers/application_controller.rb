# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    respond_to do |format|
      format.json { render json: [t('pundit.not_authorized')], status: :unauthorized }
      format.js { render json: [t('pundit.not_authorized')], status: :unauthorized }
      format.html do
        flash[:alert] = exception.message
        redirect_to root_path
      end
    end
  end
end
