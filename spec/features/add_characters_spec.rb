# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'AddCharacters', type: :feature do
  scenario 'Add an EVE online character should succeed' do
    visit user_crest_omniauth_authorize_path
  end
end
