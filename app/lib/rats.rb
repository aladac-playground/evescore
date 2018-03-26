# frozen_string_literal: true

module Rats
  class Attributes < GenericAttributes
    HELPER_PRESENTERS = [
      { name: :web, title: 'Stasis Webifier', attributes: %i[web_range web_duration maximum_velocity_bonus] },
      { name: :neut, title: 'Energy Neutrilizer', attributes: %i[neutralization_optimal_range neutralization_duration neutralization_amount] },
      { name: :scram, title: 'Warp Scramble', attributes: %i[warp_disruption_range warp_scramble_strength] }
    ].freeze

    HELPER_PRESENTERS.each do |row|
      define_method(row[:name]) do
        { icon: row[:name].to_s, title: row[:title], attributes: row[:attributes].map { |a| send(a).to_helper_attribute } }
      end
    end
  end
end
