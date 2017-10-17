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
    character_image(character.id, 32, 'data-toggle' => 'tooltip', 'data-placement' => 'top', title: title.html_safe)
  end

  def character_image(character_id, size = 64, options = {})
    options['class'] = 'img-rounded portrait'
    image_tag "https://image.eveonline.com/Character/#{character_id}_#{size}.jpg", options
  end

  def type_image(type_id, size = 32, options = {})
    options['class'] = 'img-rounded'
    image_tag("https://image.eveonline.com/Type/#{type_id}_#{size}.png", options)
  end

  def kill_image(kill)
    title = "<strong>#{kill.rat.name}</strong><br>#{kill.amount} kills"
    type_image(kill.rat.id, 32, 'data-toggle' => 'tooltip', 'data-placement' => 'top', title: title.html_safe)
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

  def corporation_image(corporation_id, size = 32)
    image_tag("https://image.eveonline.com/Corporation/#{corporation_id}_#{size}.png", class: 'img img-rounded')
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
      content_tag(:span, 'Bounty', class: 'label label-primary')
    when 'agent_mission_reward'
      content_tag(:span, "#{record.agent.division} Mission Level #{record.agent.level} Reward", class: 'label label-primary')
    end
  end
end
