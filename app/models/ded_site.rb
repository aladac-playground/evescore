class DedSite
  include Mongoid::Document
  field :name, type: String
  field :level, type: String
  field :boss_id, type: Integer
end
