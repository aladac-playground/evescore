# frozen_string_literal: true

class Character
  include Mongoid::Document
  include GlobalID::Identification
  include EsiCharacterApi
  field :name, type: String
  field :access_token, type: String
  field :refresh_token, type: String
  field :token_expires, type: Time
  belongs_to :corporation, optional: true
  belongs_to :user
  has_many :wallet_records
  has_many :kills

  after_save :create_corporation
  after_create :queue_initial_import

  def queue_initial_import
    CharacterWalletImportJob.perform_later(self)
  end

  def create_corporation
    Corporation.create_from_api(corporation_id)
  end

  def wallet_journal
    wallet_api.get_characters_character_id_wallet_journal(id)
  end

  def import_wallet
    wallet_journal.select { |r| WalletRecord.importable?(r.ref_type) }.each do |wallet_record|
      WalletRecord.create_from_api(self, wallet_record)
    end
  end

  def earnings_by_day
    WalletRecord.earnings_by_day(id).map do |b|
      OpenStruct.new(date: b['_id'].to_date, amount: b['amount'])
    end
  end

  def kills_by_bounty
    Kill.kills_by_bounty(id).map do |k|
      OpenStruct.new(rat: Rat.find(k['_id']['rat_id']),
                     amount: k['amount'])
    end
  rescue Mongoid::Errors::DocumentNotFound
    []
  end

  def kills_by_faction
    Kill.kills_by_faction(id).map do |k|
      OpenStruct.new(faction: Faction.find(k['_id']), amount: k['amount']) if k['_id']
    end.compact
  rescue Mongoid::Errors::DocumentNotFound
    []
  end

  def average_tick
    wallet_records.sum(:amount) / wallet_records.count
  rescue ZeroDivisionError
    0
  end

  def total_isk
    wallet_records.sum(:amount)
  end

  def total_kills
    kills.sum(:amount)
  end

  def favourite_faction
    kills_by_faction.first.faction
  rescue NoMethodError
    OpenStruct.new
  end
end
