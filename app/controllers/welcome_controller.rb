# frozen_string_literal: true

class WelcomeController < ApplicationController
  before_action :set_character, only: %i[character_profile destroy earnings]

  def index
    @characters = current_user.characters || []
  end

  def character_profile
    @ticks = @character.wallet_records.order('ts desc').limit(5)
    @earnings_by_day = @character.earnings_by_day[0..4]
    @valuable_rats = @character.kills_by_bounty[0..4]
    @top_ticks = @character.wallet_records.order('amount desc').limit(5)
  end

  def earnings
    @earnings_by_day = Kaminari.paginate_array(@character.earnings_by_day).page(params[:page]).per(10)
  end

  def destroy
    @character.destroy
    redirect_to root_path, notice: 'Character removed'
  end

  protected

  def set_character
    @character = Character.find(params[:character_id].to_i)
  end
end
