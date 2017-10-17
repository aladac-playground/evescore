class CharacterWalletImportJob < ApplicationJob
  queue_as :default

  def perform(character)
    character.import_wallet
  end
end
