# frozen_string_literal: true

class Corporation
  include Mongoid::Document
  field :name, type: String
  field :npc, type: Boolean
  has_many :characters
  has_many :agents
end
