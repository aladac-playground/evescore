# frozen_string_literal: true

class Faction
  include Mongoid::Document
  field :name, type: String
  field :pattern, type: Regexp
  validates :name, uniqueness: true
  belongs_to :corporation, optional: true
  has_many :rats

  def self.detect(string)
    output = nil
    all.each do |faction|
      next if faction.pattern.nil?
      if faction.pattern.compile.match?(string)
        output = faction
        break
      end
    end
    output
  end
end
