# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Pages', type: :feature do
  before(:each) do
    @user = create(:user)
    create(:corporation, :corp1)
    create(:corporation, :corp2)
    create(:agent, :agent1)
    create(:agent, :agent2)

    @character = create(:character, user_id: @user.id)
    @character.import_wallet
  end

  context 'Main page' do
    it 'should load w/o errors' do
      visit '/'
    end
  end

  context 'Profile Page' do
    it 'should load w/o errors' do
      visit character_profile_path(@character)
    end
  end
end
