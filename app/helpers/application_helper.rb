# frozen_string_literal: true

module ApplicationHelper
  def character_image(character_id, size = 64)
    image_tag "https://image.eveonline.com/Character/#{character_id}_#{size}.jpg", class: 'img-rounded'
  end
end
