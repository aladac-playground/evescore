# frozen_string_literal: true

class Rat
  include Mongoid::Document
  field :name, type: String
  field :faction, type: String
  field :group, type: String
  field :bounty, type: Float
  has_many :kills

  before_save :details_from_api, :set_faction

  FACTIONS = [
    'Guristas'
  ].freeze

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
    FACTIONS.each do |faction|
      group =~ /#{faction}/
      self.faction = faction
      break
    end
  end
  
  def rat_attributes
    types_api.dogma_attributes.map { |attribute|
      {
        ESI::DogmaApi.new.get_dogma_attributes_attribute_id(attribute.attribute_id).description => attribute.value
      }
    }
  end
end
