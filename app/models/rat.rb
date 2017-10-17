# frozen_string_literal: true

class Rat
  include Mongoid::Document
  field :name, type: String
  field :group, type: String
  field :bounty, type: Float
  field :faction_name, type: String
  has_many :kills
  belongs_to :faction, optional: true

  before_save :details_from_api, :set_faction

  def details_from_api
    rat = ESI::UniverseApi.new.get_universe_types_type_id(id)
    group = ESI::UniverseApi.new.get_universe_groups_group_id(rat.group_id)
    self.bounty = rat.dogma_attributes.select { |a| a.attribute_id == 481 }.first.value
    self.name = rat.name
    self.group = group.name
  end

  def types_api
    ESI::UniverseApi.new.get_universe_types_type_id(id)
  end

  def set_faction
    faction = Faction.detect(group)
    return false unless faction
    self.faction_name = faction.name
    self.faction_id = faction.id
  end

  def rat_attributes
    types_api.dogma_attributes.map do |attribute|
      {
        ESI::DogmaApi.new.get_dogma_attributes_attribute_id(attribute.attribute_id).description => attribute.value
      }
    end
  end
end
