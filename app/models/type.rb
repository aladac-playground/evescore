# frozen_string_literal: true

class Type
  include Mongoid::Document
  include ApiAttributes
  field :name, type: String
  field :description, type: String

  def assign_to_rat(rat)
    loot = Loot.where(id: id, name: name, description: description).first_or_create
    rat.loot << loot
  end
end
