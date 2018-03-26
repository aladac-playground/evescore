# frozen_string_literal: true

module RatsHelper
  def structure_hitpoints
    icon_tag('structure', @attributes.hp.display_name) + number_with_delimiter(@attributes.hp.value.to_i) + ' HP'
  rescue StandardError
    '-'
  end

  def armor_hitpoints
    icon_tag('armor', @attributes.armor_hp.display_name) + number_with_delimiter(@attributes.armor_hp.value.to_i) + ' HP'
  rescue StandardError
    '-'
  end

  def shield_capacity
    icon_tag('shield', @attributes.shield_capacity.display_name) + number_with_delimiter(@attributes.shield_capacity.value.to_i) + ' HP'
  rescue StandardError
    '-'
  end

  def shield_resistance(type)
    number_with_delimiter((100 - @attributes.send("shield_#{type}_damage_resonance").value * 100).to_i) + ' %'
  rescue StandardError
    '0 %'
  end

  def armor_resistance(type)
    number_with_delimiter((100 - @attributes.send("armor_#{type}_damage_resonance").value * 100).to_i) + ' %'
  rescue StandardError
    '0 %'
  end

  def turret_damage(type)
    number_with_precision((@attributes.send("#{type}_damage").value * @attributes.damage_multiplier.value), precision: 2, delimiter: ',')
  rescue StandardError
    '-'
  end

  def missile_damage(type)
    multiplier = @attributes.try(:missile_damage_multiplier).try(:value) || 1
    number_with_precision((@missile_attributes.send("#{type}_damage").value * multiplier / (@attributes.missile_launch_duration.value / 1000)), precision: 2, delimiter: ',')
  rescue StandardError
    '-'
  end

  def total_turret_damage
    total = @attributes.summarize_damage * @attributes.damage_multiplier.value
    icon_tag('turret', 'Turret DPS') + number_with_precision(total, precision: 2, delimiter: ',')
  rescue StandardError
    icon_tag('turret', 'Turret DPS') + '-'
  end

  def total_missile_damage
    total = @missile_attributes.summarize_damage / (@attributes.missile_launch_duration.value / 1000)
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
    other_effects(@attributes.web)
  rescue StandardError
    ''
  end

  def neut
    other_effects(@attributes.neut)
  rescue StandardError
    ''
  end

  def scram
    other_effects(@attributes.scram)
  rescue StandardError
    ''
  end

  def bounty
    icon_tag('isk') + ' ' + number_with_delimiter(@attributes.entity_kill_bounty.value.to_i) + ' ISK'
  rescue StandardError
    '-'
  end
end
