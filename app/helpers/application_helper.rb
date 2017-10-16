# frozen_string_literal: true

module ApplicationHelper
  def character_image(character_id, size = 64)
    image_tag "https://image.eveonline.com/Character/#{character_id}_#{size}.jpg", class: 'img-rounded'
  end

  def type_image(type_id, size = 32, options = {})
    options['class'] = 'img-rounded'
    image_tag("https://image.eveonline.com/Type/#{type_id}_#{size}.png", options)
  end

  def kill_image(kill)
    title = "<strong>#{kill.rat.name}</strong><br>#{kill.amount} kills"
    type_image(kill.rat_id, 32, 'data-toggle' => 'tooltip', 'data-placement' => 'top', title: title.html_safe)
  end

  def number_to_isk(amount)
    number_to_currency amount, format: '%n %u', precision: 0, unit: 'ISK'
  end

  def isk_image
    type_image(29, 32)
  end

  def corporation_image(corporation_id, size = 32)
    image_tag("https://image.eveonline.com/Corporation/#{corporation_id}_#{size}.png")
  end

  def record_icon(record)
    case record.type
    when 'bounty_prizes'
      corporation_image(1_000_125)
    when 'agent_mission_reward'
      corporation_image(record.agent.corporation_id)
    end
  end

  def record_details(record)
    case record.type
    when 'bounty_prizes'
      content_tag(:span, 'Bounty', class: 'label label-default')
    when 'agent_mission_reward'
      content_tag(:span, "#{record.agent.division} Mission Level #{record.agent.level} Reward", class: 'label label-primary')
    end
  end
end
