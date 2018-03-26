# frozen_string_literal: true

class Charge
  include Mongoid::Document
  include ApiAttributes
  field :name, type: String
  field :description, type: String

  alias charge_attributes api_attributes

  def types_api
    ESI::UniverseApi.new.get_universe_types_type_id(id)
  end
end
