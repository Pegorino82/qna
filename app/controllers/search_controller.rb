# frozen_string_literal: true

class SearchController < ApplicationController
  AVAILABLE_MODELS = %w[question answer comment user]
  START_PAGE = 1

  before_action :search_params

  def search
    @results = Services::Search.new(**search_service_params).search if can_search?

    render partial: 'search/result'
  end

  private

  def can_search?
    !params['text'].blank? && !classes.empty?
  end

  def search_service_params
    { text: params[:text], classes: classes, page: @page }
  end

  def search_params
    @search_params = request.params
    @page = @search_params.delete('page') || START_PAGE
  end

  def classes
    r = []
    request.params.each do |param, value|
      r << param.classify.constantize if (AVAILABLE_MODELS.include? param) && (value.to_i == 1)
    end
    r
  end
end
