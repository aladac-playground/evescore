# frozen_string_literal: true

class Faction
  include Mongoid::Document
  field :name, type: String
  field :pattern, type: Regexp
  validates :name, uniqueness: true
  belongs_to :corporation, optional: true
  has_many :rats
  
  scope :with_pattern, -> { where(:pattern.ne => nil) }

  def self.detect(string)
    all.each do |faction|
      next if faction.pattern.nil?
      return faction if faction.pattern.compile.match?(string)
    end
    nil
  end
end
