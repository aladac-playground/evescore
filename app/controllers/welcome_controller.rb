# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @characters = current_user.characters || []
  end

  def character_profile
    @character = Character.find(params[:character_id].to_i)
    @ticks = @character.wallet_records.order('ts desc').limit(10)
    @bounty_by_day = @character.bounty_by_day[0..9]
    @valuable_rats = @character.kills.order("bounty desc").limit(10)
    @top_ticks = @character.wallet_records.order('amount desc').limit(10)
  end
end
