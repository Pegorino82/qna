# frozen_string_literal: true

class AwardsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @awards = current_user.awards
  end
end
