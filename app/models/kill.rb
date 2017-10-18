# frozen_string_literal: true

class Kill
  include Mongoid::Document
  field :ts, type: Time
  field :date, type: Date
  field :amount, type: Integer
  field :bounty, type: Float
  belongs_to :wallet_record
  belongs_to :rat, optional: true
  belongs_to :faction, optional: true
  belongs_to :user, optional: true
  after_create :create_rat
  belongs_to :character

  delegate :name, to: :rat

  def create_rat
    rat = Rat.where(id: rat_id).first_or_create
    update_attributes(bounty: rat.bounty) if bounty.nil?
    update_attributes(faction_id: rat.faction_id) if faction_id.nil?
  end

  def self.user_kills_by_bounty(user_id)
    collection.aggregate([
                           { '$match' => { 'user_id' => user_id } },
                           { '$group' => {
                             '_id' => { rat_id: '$rat_id', bounty: '$bounty' },
                             'amount' => { '$sum' => '$amount' }
                           } },
                           { '$sort' => { '_id.bounty' => -1 } }
                         ])
  end

  def self.kills_by_faction(character_id)
    collection.aggregate([
                           { '$match' => { 'character_id' => character_id } },
                           { '$group' => {
                             '_id' => '$faction_id',
                             'amount' => { '$sum' => '$amount' }
                           } },
                           { '$sort' => { 'amount' => -1 } }
                         ])
  end

  def self.user_kills_by_faction(user_id)
    collection.aggregate([
                           { '$match' => { 'user_id' => user_id } },
                           { '$group' => {
                             '_id' => '$faction_id',
                             'amount' => { '$sum' => '$amount' }
                           } },
                           { '$sort' => { 'amount' => -1 } }
                         ])
  end
end
