# frozen_string_literal: true

module ApiAttributes
  extend ActiveSupport::Concern

  def api_attributes
    types_api.dogma_attributes.map do |attribute|
      dgm = DogmaAttributeType.find(attribute.attribute_id)
      OpenStruct.new(id: dgm.id,
                     name: dgm.attribute_name,
                     display_name: dgm.display_name.try(:titleize),
                     value: attribute.value,
                     description: dgm.description)
    end.reject(&:zero?).select(&:display_name)
  end
end
