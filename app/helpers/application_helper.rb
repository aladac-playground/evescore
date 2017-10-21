# frozen_string_literal: true

module ApplicationHelper
  def flash_to_alert(flash)
    case flash[0]
    when 'notice'
      html_class = 'info'
    when 'error', 'alert'
      html_class = 'danger'
    when 'warn'
      html_class = 'warning'
    end
    content_tag(:div, close_button('alert') + flash[1], class: "alert alert-dismissible alert-#{html_class}")
  end

  def close_button(type)
    "<button type=\"button\" class=\"close\" data-dismiss=\"#{type}\">×</button>".html_safe
  end

  def icon(name)
    content_tag(:span, '', class: "glyphicon glyphicon-#{name}")
  end

  def login_with_eve
    link_to image_tag('EVE_SSO_Login_Buttons_Small_Black.png'), user_crest_omniauth_authorize_path
  end

  def navbar_portrait(character)
    title = character.name
    character_image(character.id, 32, tooltip(title))
  end

  def character_image(character_id, size = 64, options = {})
    options[:class] = 'img-rounded portrait'
    image_tag "https://image.eveonline.com/Character/#{character_id}_#{size}.jpg", options
  end

  def type_image(type_id, size = 32, options = {})
    ded_boss = DedSite.all.map(&:boss_id).include?(type_id)
    options[:class] = 'img-rounded cursor-hand'
    options[:style] = 'border: 1px solid; border-color: red' if ded_boss
    # concat = '&nbsp;'.html_safe
    image_tag("https://image.eveonline.com/Type/#{type_id}_#{size}.png", options)
  end

  def kill_image(kill)
    kill = OpenStruct.new(kill) if kill.class == BSON::Document
    title = "<strong>#{kill.name}</strong><br>#{kill.amount} kills"
    type_image(kill.rat_id, 32, tooltip(title))
  rescue ActionView::Template::Error
    ''
  end

  def number_to_isk(amount)
    number_to_currency amount, format: '%n %u', precision: 0, unit: 'ISK'
  end

  def number_to_isk_short(amount)
    number_to_human amount, units: { thousand: 'K ISK', million: 'M ISK', billion: 'b ISK' }, format: '%n%u'
  end

  def isk_image
    type_image(29, 32)
  end

  def corporation_image(corporation_id, size = 32, options = {})
    options[:class] = 'img-rounded'
    image_tag("https://image.eveonline.com/Corporation/#{corporation_id}_#{size}.png", options)
  end

  def faction_image(faction_id)
    faction = Faction.find(faction_id)
    corporation_image faction.corporation_id, 32, tooltip(faction.corporation.name)
  end

  def record_icon(record)
    case record.type
    when 'bounty_prizes'
      corporation_image(1_000_125, 32, tooltip('CONCORD'))
    when 'agent_mission_reward', 'agent_mission_time_bonus_reward'
      options = tooltip Corporation.find(record.agent.corporation_id).name
      corporation_image(record.agent.corporation_id, 32, options)
    end
  end

  def tooltip(title)
    { data: { toggle: 'tooltip', placement: 'top' }, title: title }
  end

  def mission_level_label(mission_level)
    classes = { 1 => 'success', 2 => 'info', 3 => 'warning', 4 => 'danger', 5 => 'purple' }
    content_tag(:span, "LEVEL #{mission_level}", class: "label label-#{classes[mission_level]}")
  end

  def mission_label(agent, type = 'Mission')
    mission_level_label(agent.level) + '&nbsp;'.html_safe + content_tag(:span, "#{agent.division} #{type}", class: 'label label-primary')
  end

  def ded_site?(ded_site, options = {})
    return if ded_site.blank?
    ded_site = OpenStruct.new(ded_site) if ded_site.class == BSON::Document
    options[:class] = 'label label-danger cursor-hand'
    options.merge! tooltip(ded_site.name)
    '&nbsp;'.html_safe + content_tag(:span, "DED #{ded_site.level}", options)
  end

  def record_details(record)
    case record.type
    when 'bounty_prizes'
      concat content_tag(:span, 'Bounty', class: 'label label-primary')
      ded_site?(record.ded_site)
    when 'agent_mission_reward'
      mission_label(record.agent)
    when 'agent_mission_time_bonus_reward'
      mission_label(record.agent, 'Mission Time Bonus')
    end
  end
end
