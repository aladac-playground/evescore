# frozen_string_literal: true

class WelcomeController < ApplicationController
  before_action :set_character, only: :character_profile

  def index
    @characters = current_user.characters || []
  end

  def character_profile
    @ticks = @character.wallet_records.order('ts desc').limit(5)
    @bounty_by_day = @character.bounty_by_day[0..4]
    @valuable_rats = @character.kills_by_bounty[0..4]
    @top_ticks = @character.wallet_records.order('amount desc').limit(5)
  end

  protected

  def set_character
    @character = Character.find(params[:character_id].to_i)
  end
end
