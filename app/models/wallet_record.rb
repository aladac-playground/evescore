# frozen_string_literal: true

class WalletRecord
  include Mongoid::Document
  field :ts, type: Time
  field :date, type: Date
  field :amount, type: Float
  field :tax, type: Float
  field :type, type: String
  field :ref_id, type: Integer
  index({ character_id: 1, ts: 1 }, unique: true, drop_dups: true)
  belongs_to :character
  belongs_to :user, optional: true
  belongs_to :agent, optional: true
  has_many :kills, autosave: true
  validates :ts, uniqueness: { scope: :character_id }

  IMPORTABLE_REF_TYPES = %w[
    agent_mission_reward
    bounty_prizes
  ].freeze

  def self.importable?(type)
    return true if IMPORTABLE_REF_TYPES.include?(type)
  end

  def self.create_from_api(character_id, user_id, wallet_record)
    record = new(
      amount: wallet_record.amount, tax: wallet_record.tax || 0, ts: wallet_record.date, date: wallet_record.date.to_date, user_id: user_id,
      type: wallet_record.ref_type, ref_id: wallet_record.ref_id, character_id: character_id, agent_id: wallet_record.first_party_id
    )
    record.build_kills(wallet_record.reason)
    record.save
  end

  def self.earnings_by_day(character_id)
    collection.aggregate([
                           { '$match' => { 'character_id' => character_id } },
                           { '$group' => {
                             '_id' => '$date',
                             'amount' => { '$sum' => '$amount' }
                           } },
                           { '$sort' => { '_id' => -1 } }
                         ])
  end

  def self.user_earnings_by_day(user_id)
    collection.aggregate([
                           { '$match' => { 'user_id' => user_id } },
                           { '$group' => {
                             '_id' => '$date',
                             'amount' => { '$sum' => '$amount' }
                           } },
                           { '$sort' => { '_id' => -1 } }
                         ])
  end

  def parse_rats(text)
    text.split(',').map { |a| a.split(":\s") }
  end

  def build_kills(text)
    parse_rats(text).each do |rat_info|
      kills.build(rat_id: rat_info[0].to_i, amount: rat_info[1], date: date, ts: ts, character_id: character_id, user_id: user_id)
    end
  end
end
