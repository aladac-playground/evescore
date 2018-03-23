# frozen_string_literal: true

class WalletRecord
  include Mongoid::Document
  field :ts, type: Time
  field :date, type: Date
  field :amount, type: Float
  field :tax, type: Float
  field :type, type: String
  field :ref_id, type: Integer
  field :mission_level, type: Integer
  index({ character_id: 1, ts: 1 }, unique: true, drop_dups: true)
  belongs_to :character
  belongs_to :user, optional: true
  belongs_to :agent, optional: true
  belongs_to :ded_site, optional: true
  has_many :kills, autosave: true
  validates :ts, uniqueness: { scope: %i[character_id ref_id] }

  scope :ded_sites, -> { where(:ded_site_id.ne => nil) }
  scope :missions, -> { where(:mission_level.ne => nil) }

  IMPORTABLE_REF_TYPES = %w[
    agent_mission_time_bonus_reward
    agent_mission_reward
    bounty_prizes
  ].freeze

  def self.importable?(type)
    return true if IMPORTABLE_REF_TYPES.include?(type)
  end

  def self.create_from_api(character_id, user_id, wallet_record)
    record = new(
      amount: wallet_record.amount, tax: wallet_record.tax || 0, ts: wallet_record.date, date: wallet_record.date.to_date, user_id: user_id,
      type: wallet_record.ref_type, ref_id: wallet_record.ref_id, character_id: character_id, agent_id: wallet_record.first_party_id,
      mission_level: mission_level(wallet_record.first_party_id)
    )
    record.build_kills(wallet_record.reason)
    record.save
  end

  def self.mission_level(agent_id)
    Agent.find(agent_id).level
  rescue Mongoid::Errors::DocumentNotFound
    nil
  end

  def parse_rats(text)
    text.split(',').map { |a| a.split(":\s") }
  end

  def check_ded_site_id(rat_id)
    DedSite.where(boss_id: rat_id.to_i).first.id
  end

  def kills_present?(text)
    return false if text.blank? || text.match(/(\d+:+\s+\d+,?)+/).blank?
    assign_ded_site(text)
    true
  end

  def assign_ded_site(text)
    pattern = DedSite.all.map(&:boss_id).join('|')
    match = ::Regexp.new("(#{pattern})")
    boss_match = text.match(match)
    self.ded_site_id = check_ded_site_id(boss_match[1]) if !pattern.empty? && boss_match
  end

  def build_kills(text)
    return false unless kills_present?(text)
    parse_rats(text).each do |rat_info|
      kills.build(rat_id: rat_info[0].to_i, amount: rat_info[1], date: date, ts: ts, character_id: character_id, user_id: user_id)
    end
  end

  def self.public_records
    where(:character_id.in => Character.public_characters.map(&:id))
  end

  def self.public_top_ticks
    public_records.order('amount desc')
  end

  def self.aggregate_public_top_pipeline(query, limit)
    pipeline = query.pipeline
    pipeline.push('$limit' => limit) if limit
    collection.aggregate pipeline
  end

  def self.public_top_isk(limit = nil)
    query = public_records.group(_id: '$character_id', :amount.sum => '$amount').desc(:amount)
    aggregate_public_top_pipeline(query, limit)
  end

  def self.public_top_average_ticks(limit = nil)
    query = public_records.group(_id: '$character_id', :amount.avg => '$amount').desc(:amount)
    aggregate_public_top_pipeline(query, limit)
  end
end
