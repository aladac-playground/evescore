# frozen_string_literal: true

module ImageHelper
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

  def isk_image
    type_image(29, 32)
  end

  def alliance_image(alliance_id, size = 32, options = {})
    options[:class] = 'img-rounded'
    image_tag("https://image.eveonline.com/Alliance/#{alliance_id}_#{size}.png", options)
  end

  def corporation_image(corporation_id, size = 32, options = {})
    options[:class] = 'img-rounded'
    image_tag("https://image.eveonline.com/Corporation/#{corporation_id}_#{size}.png", options)
  end

  def faction_image(faction_id)
    return '-' if faction_id.blank?
    faction = Faction.find(faction_id)
    corporation_image faction.corporation_id, 32, tooltip(faction.corporation.name)
  end
end
