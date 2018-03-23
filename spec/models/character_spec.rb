# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Character, type: :model do
  context '#wallet_journal' do
    let(:character) { build(:character) }
    it 'gets wallet journal from API' do
      VCR.use_cassette :wallet_journal, record: :new_episodes do
        expect { character.wallet_journal }.not_to raise_error
      end
    end
  end

  context '#import_wallet' do
    let(:character) do
      user = create(:user)
      create(:character, user_id: user.id)
    end
    it 'imports wallet records', vcr: true do
      VCR.use_cassette :corporation, record: :new_episodes do
        expect { character.import_wallet }.not_to raise_error
      end
    end
  end

  context '.create' do
    it 'creates a Character and triggers callbacks' do
      user = create(:user)
      VCR.use_cassette :corporation, record: :new_episodes do
        expect { create(:character, user_id: user.id) }.not_to raise_error
      end
    end
  end
end
