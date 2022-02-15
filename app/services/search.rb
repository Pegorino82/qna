# frozen_string_literal: true

module Services
  class Search
    def initialize(params)
      @text = ThinkingSphinx::Query.escape(params[:text])
      @classes = params[:classes]
      @page = params[:page]
    end

    def search
      ThinkingSphinx.search @text, classes: @classes, page: @page, per_page: 5
    end
  end
end
