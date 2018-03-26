# frozen_string_literal: true

module RatsHelper
  def structure_hitpoints
    icon_tag('structure', @attributes.structure_hitpoints.display_name) + number_with_delimiter(@attributes.structure_hitpoints.value.to_i) + ' HP'
  rescue StandardError
    '-'
  end

  def armor_hitpoints
    icon_tag('armor', @attributes.armor_hitpoints.display_name) + number_with_delimiter(@attributes.armor_hitpoints.value.to_i) + ' HP'
  rescue StandardError
    '-'
  end

  def shield_capacity
    icon_tag('shield', @attributes.shield_capacity.display_name) + number_with_delimiter(@attributes.shield_capacity.value.to_i) + ' HP'
  rescue StandardError
    '-'
  end

  def shield_resistance(type)
    number_with_delimiter((100 - @attributes.send("shield_#{type}_damage_resistance").value * 100).to_i) + ' %'
  rescue StandardError
    '0 %'
  end

  def armor_resistance(type)
    number_with_delimiter((100 - @attributes.send("armor_#{type}_damage_resistance").value * 100).to_i) + ' %'
  rescue StandardError
    '0 %'
  end

  def turret_damage(type)
    number_with_precision((@attributes.send("#{type}_damage").value * @attributes.damage_modifier.value), precision: 2, delimiter: ',')
  rescue StandardError
    '-'
  end

  def missile_damage(type)
    number_with_precision((@missile_attributes.send("#{type}_damage").value * @attributes.missile_damage_bonus.value / (@attributes.missile_rate_of_fire.value / 1000)), precision: 2, delimiter: ',')
  rescue StandardError
    '-'
  end

  def total_turret_damage
    total = @attributes.summarize_damage * @attributes.damage_modifier.value
    icon_tag('turret', 'Turret DPS') + number_with_precision(total, precision: 2, delimiter: ',')
  rescue StandardError
    icon_tag('turret', 'Turret DPS') + '-'
  end

  def total_missile_damage
    total = @missile_attributes.summarize_damage / (@attributes.missile_rate_of_fire.value / 1000)
    icon_tag('missile_launcher', 'Missle DPS') + ' ' + number_with_precision(total, precision: 2, delimiter: ',')
  rescue StandardError
    icon_tag('missile_launcher', 'Missle DPS') + '-'
  end

  def resistance(type)
    icon_tag("#{type}_resist", "#{type.to_s.capitalize} Resistance")
  rescue StandardError
    ''
  end

  def damage(type)
    icon_tag("#{type}_damage", "#{type.to_s.capitalize} Damage")
  rescue StandardError
    ''
  end

  def other_effects(opts)
    text = +"<strong><em>#{opts[:title]}</em></strong><br>"
    opts[:attributes].each do |attribute|
      text << "<strong>#{attribute[:name]}:</strong> #{attribute[:value]} #{attribute[:unit]}<br>"
    end
    icon_tag(opts[:icon], text)
  rescue StandardError
    ''
  end

  def web
    attributes = [
      { name: 'Range', value: number_with_delimiter(@attributes.web_range.value.to_i), unit: 'm' },
      { name: 'Duration', value: (@attributes.web_duration.value / 1000).to_i, unit: 's' },
      { name: 'Penalty', value: @attributes.maximum_velocity_bonus.value.to_i, unit: '%' }
    ]
    other_effects(title: 'Stasis Webifier', icon: 'web', attributes: attributes)
  end

  def neut
    attributes = [
      { name: 'Range', value: number_with_delimiter(@attributes.neutralization_optimal_range.value.to_i), unit: 'm' },
      { name: 'Duration', value: (@attributes.neutralization_duration.value / 1000).to_i, unit: 's' },
      { name: 'Amount', value: @attributes.neutralization_amount.value.to_i, unit: 'GJ' }
    ]
    other_effects(title: 'Energy Neutralizer', icon: 'neut', attributes: attributes)
  end

  def bounty
    icon_tag('isk') + ' ' + number_with_delimiter(@attributes.bounty.value.to_i) + ' ISK'
  rescue StandardError
    '-'
  end
end
