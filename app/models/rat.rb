# frozen_string_literal: true

class Rat
  include Mongoid::Document
  include ApiAttributes
  field :name, type: String
  field :bounty, type: Float
  field :faction_name, type: String
  has_many :kills
  belongs_to :faction, optional: true
  belongs_to :group

  before_save :details_from_api, :set_faction

  alias rat_attributes api_attributes

  def details_from_api
    rat = ESI::UniverseApi.new.get_universe_types_type_id(id)
    group = ESI::UniverseApi.new.get_universe_groups_group_id(rat.group_id)
    self.bounty = begin
                    rat.dogma_attributes.select { |a| a.attribute_id == 481 }.first.try(:value)
                  rescue StandardError
                    nil
                  end
    self.name = rat.name
    self.group = group.group_id
  end

  def types_api
    ESI::UniverseApi.new.get_universe_types_type_id(id)
  end

  def description
    types_api.description
  end

  def set_faction
    faction = Faction.detect(group.name) || Faction.detect(name)
    return false unless faction
    self.faction_name = faction.name
    self.faction_id = faction.id
  end

  def structure_hitpoints
    rat_attributes.select { |a| a.id == 9 }[0]
  end
end
