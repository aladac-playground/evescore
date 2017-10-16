# frozen_string_literal: true

class Kill
  include Mongoid::Document
  field :ts, type: Time
  field :date, type: Date
  field :amount, type: Integer
  field :bounty, type: Float
  belongs_to :wallet_record
  belongs_to :rat, optional: true
  after_create :create_rat
  belongs_to :character

  def create_rat
    rat = Rat.where(id: rat_id).first_or_create
    update_attributes(bounty: rat.bounty) if bounty.nil?
  end

  def self.kills_by_bounty(character_id)
    collection.aggregate([
                           { '$match' => { 'character_id' => character_id } },
                           { '$group' => {
                             '_id' => { rat_id: '$rat_id', bounty: '$bounty' },
                             'kills' => { '$sum' => '$amount' }
                           } },
                           { '$sort' => { '_id.bounty' => -1 } }
                         ])
  end
end
