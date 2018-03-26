# frozen_string_literal: true

class FactionsController < ApplicationController
  def index
    @factions = Faction.legit
  end

  def show
    @faction = Faction.find(params[:id].to_i)
    @groups = @faction.groups.sort_by(&:name)
  end

  def groups
    @group = Group.find(params[:group_id].to_i)
    @rats = Rat.where(group_id: params[:group_id].to_i, faction_id: params[:faction_id].to_i)
  end

  def factionless
    @groups = Group.where(faction_id: nil).sort('name desc')
  end

  def factionless_group
    @group = Group.find(params[:group_id].to_i)
  end
end
