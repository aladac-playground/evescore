# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @characters = current_user.characters || []
  end

  def character_profile
    @character = Character.find(params[:character_id])
  end
end
