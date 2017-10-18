# frozen_string_literal: true

class Character
  include Mongoid::Document
  include GlobalID::Identification
  include EsiCharacterApi
  include ProfileStats
  field :name, type: String
  field :access_token, type: String
  field :refresh_token, type: String
  field :token_expires, type: Time
  belongs_to :corporation, optional: true
  belongs_to :user
  has_many :wallet_records
  has_many :kills
  embeds_many :earnings

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
      WalletRecord.create_from_api(id, user_id, wallet_record)
    end
  end
end
