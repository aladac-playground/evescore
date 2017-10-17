# frozen_string_literal: true

desc 'Clear Rat, WallerRecord and Kill records'
task clear_data: :environment do
  log = Logger.new(STDOUT)
  log.info 'Deleting Rats'
  Rat.delete_all
  log.info 'Deleting WalletRecords'
  WalletRecord.delete_all
  log.info 'Deleting Kills'
  Kill.delete_all
end
