# frozen_string_literal: true

class DedSite
  include Mongoid::Document
  field :name, type: String
  field :level, type: String
  field :boss_id, type: Integer
  belongs_to :faction
end
