# frozen_string_literal: true

class Charge
  include Mongoid::Document
  field :name, type: String
  field :description, type: String

  def types_api
    ESI::UniverseApi.new.get_universe_types_type_id(id)
  end

  def charge_attributes
    types_api.dogma_attributes.map do |attribute|
      dgm = DogmaAttributeType.find(attribute.attribute_id)
      OpenStruct.new(id: dgm.id,
                     name: dgm.attribute_name,
                     display_name: dgm.display_name.try(:titleize),
                     value: attribute.value,
                     description: dgm.description)
    end
  end
end
