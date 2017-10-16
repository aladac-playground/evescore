# frozen_string_literal: true

class WelcomeController < ApplicationController
  before_action :set_character, only: :character_profile

  def index
    @characters = current_user.characters || []
  end

  def character_profile
    @ticks = @character.wallet_records.order('ts desc').limit(10)
    @bounty_by_day = @character.bounty_by_day[0..9]
    @valuable_rats = @character.kills.order('bounty desc').limit(10)
    @top_ticks = @character.wallet_records.order('amount desc').limit(10)
  end

  protected

  def set_character
    @character = Character.find(params[:character_id].to_i)
  end
end
