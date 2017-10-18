# frozen_string_literal: true

class Corporation
  include Mongoid::Document
  field :name, type: String
  field :npc, type: Boolean
  field :ticker, type: String
  has_many :characters
  has_many :agents
  
  def self.create_from_api(corporation_id)
    api_corporation = ESI::CorporationApi.new.get_corporations_corporation_id(corporation_id)
    where(id: corporation_id, name: api_corporation.corporation_name, ticker: api_corporation.ticker).first_or_create
  end
end
