# frozen_string_literal: true

class FactionsController < ApplicationController
  def index
    @factions = Faction.legit
  end

  def show
    @faction = Faction.find(params[:id].to_i)
    @groups = @faction.rats.pluck(:group).uniq.sort
  end

  def groups
    @group = params[:name]
    @rats = Rat.where(group: @group, faction_id: params[:faction_id].to_i)
  end
end
