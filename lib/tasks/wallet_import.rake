# frozen_string_literal: true

desc 'Perform WalletRecord import from ESI'
task import_wallet: :environment do
  logger = Logger.new(STDOUT)
  User.all.each do |user|
    user.characters.each do |character|
      start = Time.now.to_f
      logger.info "Starting import for: #{character.id}"
      character.import_wallet
      logger.info "Finished import for: #{character.id}, took: #{format '%.2f', Time.now.to_f - start} seconds"
    end
  end
end
