# frozen_string_literal: true

class WelcomeController < ApplicationController
  before_action :set_character, except: %i[index]

  DEFAULT_PER_PAGE = 10

  def index
    @characters = current_user.characters || []
  end

  def character_profile
    @ticks = @character.wallet_records.order('ts desc').limit(5)
    @earnings_by_day = @character.earnings_by_day(5)
    @valuable_rats = @character.kills_by_bounty(5)
    @top_ticks = @character.wallet_records.order('amount desc').limit(5)
  end

  def earnings
    @earnings_by_day = Kaminari.paginate_array(@character.earnings_by_day.to_a).page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def ticks
    @top_ticks = @character.wallet_records.order('amount desc').page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def rats
    @valuable_rats = Kaminari.paginate_array(@character.kills_by_bounty.to_a).page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def journal
    @ticks = @character.wallet_records.order('ts desc').page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def destroy
    @character.destroy
    redirect_to root_path, notice: 'Character removed'
  end

  def display_option
    redirect_to root_path, alert: 'Something went wrong with display option change' && return unless @character.update(character_params)
    redirect_to root_path, notice: "Display option for #{@character.name} now set to #{character_params[:display_option]}"
  end

  protected

  def set_character
    @character = Character.find(params[:character_id].to_i)
  end

  def character_params
    params.require(:character).permit(:display_option)
  end
end
