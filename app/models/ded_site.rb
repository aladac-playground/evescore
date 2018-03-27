# frozen_string_literal: true

class DedSite
  include Mongoid::Document
  field :name, type: String
  field :level, type: String
  belongs_to :faction
  has_many :bosses, class_name: 'Rat'
end
