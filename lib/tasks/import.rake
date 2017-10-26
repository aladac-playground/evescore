# frozen_string_literal: true

namespace :import do
  desc 'Import all EVE SDE and API data'
  task all: :environment do
    import_all
  end
  desc 'Import NPC corporations from EVE SDE and API data'
  task corps: :environment do
    Corporation.delete_all(npc: true)
    create_corps
  end
  desc 'Perform WalletRecord import from ESI'
  task wallets: :environment do
    import_wallets
  end
  desc 'Import NPC Factions from EVE SDE and API data'
  task factions: :environment do
    Faction.delete_all
    create_factions
  end
  desc 'Import DED Sites'
  task ded_sites: :environment do
    DedSite.delete_all
    create_ded_sites
  end
end

def logger
  Logger.new(STDOUT)
end

def import_all
  Corporation.delete_all(npc: true)
  Agent.delete_all
  Faction.delete_all
  create_corps
  create_agents
  create_factions
  create_ded_sites
end

def create_agents
  agents = YAML.load_file('data/agents.yml')
  agents.tqdm(leave: true, desc: 'Importing Mission Agents').each do |agent|
    Agent.create(agent)
  end
end

def create_corps
  corps = YAML.load_file('data/corporations.yml')
  corps.tqdm(leave: true, desc: 'Importing NPC Corporations').each do |corp|
    Corporation.create(corp)
  end
end

def create_factions
  factions = YAML.load_file('data/factions.yml')
  factions.tqdm(leave: true, desc: 'Importing Factions').each do |faction|
    Faction.create(faction)
  end
end

def create_ded_sites
  ded_sites = YAML.load_file('data/ded_sites.yml')
  ded_sites.tqdm(leave: true, desc: 'Importing DED Sites').each do |ded_site|
    DedSite.create(ded_site)
  end
end

def import_wallets
  User.all.each do |user|
    user.characters.each do |character|
      import_wallet(character)
    end
  end
end

def import_wallet(character)
  start = Time.now.to_f
  logger.info "Starting import for: #{character.id}"
  character.import_wallet
  logger.info "Finished import for: #{character.id}, took: #{format '%.2f', Time.now.to_f - start} seconds"
end
