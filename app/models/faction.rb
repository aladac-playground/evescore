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

  scope :legit, -> { where(has_rats: true) }

  def self.detect(string)
    all.each do |faction|
      next if faction.pattern.nil?
      return faction if faction.pattern.compile.match?(string)
    end
    nil
  end
end
