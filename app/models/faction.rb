# frozen_string_literal: true

class Faction
  include Mongoid::Document
  field :name, type: String
  field :pattern, type: Regexp
  field :has_rats, type: Boolean
  validates :name, uniqueness: true
  belongs_to :corporation, optional: true
  has_many :rats
  has_many :groups
  has_many :ded_sites

  scope :legit, -> { where(has_rats: true) }
  scope :ded_sites, -> { where(:id.in => [500_010, 500_011, 500_012, 500_019, 500_020]) }

  SIZES = {
    500_010 => {
      frigate: { prefix: 'Pithi', ship: 'Worm' },
      cruiser: { prefix: 'Pithum', ship: 'Gila' },
      battleship: { prefix: 'Pith', ship: 'Rattlesnake' }
    },
    500_011 => {
      frigate: { prefix: 'Gistii', ship: 'Dramiel' },
      cruiser: { prefix: 'Gistum', ship: 'Cynabal' },
      battleship: { prefix: 'Gist', ship: 'Machariel' }
    },
    500_012 => {
      frigate: { prefix: 'Corpii', ship: 'Cruor' },
      cruiser: { prefix: 'Corpum', ship: 'Ashimmu' },
      battleship: { prefix: 'Corpus', ship: 'Bhaalgorn' }
    },
    500_019 => {
      frigate: { prefix: 'Centii', ship: 'Succubus' },
      cruiser: { prefix: 'Centum', ship: 'Phantasm' },
      battleship: { prefix: 'Centus', ship: 'Nightmare' }
    },
    500_020 => {
      frigate: { prefix: 'Coreli', ship: 'Daredevil' },
      cruiser: { prefix: 'Corelum', ship: 'Vigilant' },
      battleship: { prefix: 'Core', ship: 'Vindicator' }
    }
  }.freeze

  TYPES = {
    1 => { size: :frigate, type: :c, overseer: 3 },
    2 => { size: :frigate, type: :b, overseer: 6 },
    3 => { size: :frigate, type: :a, overseer: 7 },
    4 => { size: :cruiser, type: :c, overseer: 8 },
    5 => { size: :cruiser, type: :b, overseer: 18 },
    6 => { size: :cruiser, type: :a, overseer: 19 },
    7 => { size: :battleship, type: :c, overseer: 20 },
    8 => { size: :battleship, type: :b, overseer: 21 },
    9 => { size: :battleship, type: :a, overseer: 22 },
    10 => { size: :battleship, type: :x, overseer: 23 }
  }.freeze

  def self.detect(string)
    all.each do |faction|
      next if faction.pattern.nil?
      return faction if faction.pattern.compile.match?(string)
    end
    nil
  end

  # def ded_site_loot(level)
  #   effects = "#{TYPES[level][:overseer].ordinalize} Tier Overseer's Personal Effects"
  #   prefix = SIZES[id][TYPES[level][:size]][:prefix]
  #   ship = SIZES[id][TYPES[level][:size]][:ship]
  #   type = "#{TYPES[level][:type].upcase}-Type"
  #   modules = /^#{prefix} #{type}/
  #   blueprint = "#{ship} Blueprint"
  #   Type.where(name: ::Regexp.union([effects, modules, blueprint])).each do |item|
  #     Loot.where(id: item.id, name: item.name, description: item.description).first_or_create
  #   end
  #   Loot.where(name: ::Regexp.union([effects, modules, blueprint]))
  # end
end
