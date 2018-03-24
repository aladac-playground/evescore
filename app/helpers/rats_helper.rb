# frozen_string_literal: true

module RatsHelper
  def structure_hitpoints
    icon_tag('structure', @attributes.structure_hitpoints.display_name) + number_with_delimiter(@attributes.structure_hitpoints.value.to_i) + ' HP'
  end

  def armor_hitpoints
    icon_tag('armor', @attributes.armor_hitpoints.display_name) + number_with_delimiter(@attributes.armor_hitpoints.value.to_i) + ' HP'
  end

  def shield_capacity
    icon_tag('shield', @attributes.shield_capacity.display_name) + number_with_delimiter(@attributes.shield_capacity.value.to_i) + ' HP'
  end

  def shield_resistance(type)
    number_with_delimiter((100 - @attributes.send("shield_#{type}_damage_resistance").value * 100).to_i) + ' %'
  rescue
    '0 %'
  end

  def armor_resistance(type)
    number_with_delimiter((100 - @attributes.send("armor_#{type}_damage_resistance").value * 100).to_i) + ' %'
  rescue
    '0 %'
  end

  def turret_damage(type)
    number_with_delimiter((@attributes.send("#{type}_damage").value * @attributes.damage_modifier.value))
  rescue
    '-'
  end

  def missile_damage(type)
    @missile_attributes = Charges::Attributes.new(Charge.find(@attributes.missile_type_id.value.to_i).charge_attributes)
    number_with_precision((@missile_attributes.send("#{type}_damage").value * @attributes.missile_damage_bonus.value / (@attributes.missile_rate_of_fire.value / 1000)), precision: 2, delimiter: ',')
  rescue
    '-'
  end

  def total_turret_damage
    total = 0
    %i[kinetic thermal explosive em].each do |type|
      begin
        type_damage = @attributes.send("#{type}_damage").value
      rescue
        type_damage = 0
      end
      total += type_damage
    end
    total *= @attributes.damage_modifier.value
    icon_tag('turret', 'Turret DPS') + total.to_s
  rescue
    icon_tag('turret', 'Turret DPS') + '-'
  end

  def total_missile_damage
    total = 0
    @missile_attributes = Charges::Attributes.new(Charge.find(@attributes.missile_type_id.value.to_i).charge_attributes)
    %i[kinetic thermal explosive em].each do |type|
      begin
        type_damage = @missile_attributes.send("#{type}_damage").value
      rescue
        type_damage = 0
      end
      total += type_damage
    end
    total = total * @attributes.missile_damage_bonus.value / (@attributes.missile_rate_of_fire.value / 1000)
    icon_tag('missile_launcher', 'Missle DPS') + ' ' + number_with_precision(total, precision: 2, delimiter: ',')
  rescue
    icon_tag('missile_launcher', 'Missle DPS') + '-'
  end

  def resistance(type)
    icon_tag("#{type}_resist", "#{type.to_s.capitalize} Resistance")
  rescue
    ''
  end

  def damage(type)
    icon_tag("#{type}_damage", "#{type.to_s.capitalize} Damage")
  rescue
    ''
  end

  def web
    text = "<strong>Stasis Webifier</strong><br>
      <strong>Range:</strong> #{number_with_delimiter(@attributes.web_range.value.to_i)} m<br>
      <strong>Duration:</strong> #{(@attributes.web_duration.value / 1000).to_i} s<br>
      <strong>Penalty:</strong> #{@attributes.maximum_velocity_bonus.value.to_i} %<br>
    "
    icon_tag('web', text) if @attributes.web_chance.value > 0
  rescue
    ''
  end

  def neut
    text = "<strong>Energy Neutralizer</strong><br>
      <strong>Range:</strong> #{number_with_delimiter(@attributes.neutralization_optimal_range.value.to_i)} m<br>
      <strong>Duration:</strong> #{(@attributes.neutralization_duration.value / 1000).to_i} s<br>
      <strong>Amount:</strong> #{@attributes.neutralization_amount.value.to_i} GJ<br>
    "
    icon_tag('neut', text)
  rescue
    ''
  end

  def bounty
    icon_tag('isk') + ' ' + number_with_delimiter(@attributes.bounty.value.to_i) + ' ISK'
  end
end
