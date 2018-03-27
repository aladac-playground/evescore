# frozen_string_literal: true

class Loot
  include Mongoid::Document
  include ApiAttributes
  field :name, type: String
  field :price, type: Float
  field :description, type: String
  has_and_belongs_to_many :rats

  alias loot_attributes api_attributes

  def self.assign_prices
    ESI::MarketApi.new.get_markets_prices.each do |row|
      item = where(id: row.type_id).first
      item&.update_attributes(price: row.average_price)
    end
  end
end
