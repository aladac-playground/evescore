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
  desc 'Import Dogma Attribute Types'
  task dogma_attribute_types: :environment do
    DogmaAttributeType.delete_all
    create_dogma_attribute_types
  end
  desc 'Import Charges'
  task charges: :environment do
    Charge.delete_all
    create_charges
  end
  desc 'Import Rats'
  task rats: :environment do
    create_rats
  end
  desc 'Import Groups'
  task groups: :environment do
    create_groups
  end
end

def logger
  Logger.new(STDOUT)
end

def import_all
  Corporation.delete_all(npc: true)
  Agent.delete_all
  Faction.delete_all
  DedSite.delete_all
  create_corps
  create_agents
  create_factions
  create_ded_sites
  create_dogma_attribute_types
end

def create_groups
  Group.delete_all
  ESI::UniverseApi.new.get_universe_categories_category_id(11).groups.tqdm.each do |group_id|
    group = ESI::UniverseApi.new.get_universe_groups_group_id(group_id)
    Group.create(name: group.name, id: group.group_id)
  end
end

def create_rats
  create_groups
  Rat.delete_all
  rats = ESI::UniverseApi.new.get_universe_categories_category_id(11).groups.map do |group_id|
    ESI::UniverseApi.new.get_universe_groups_group_id(group_id).types.map do |type_id|
      { id: type_id, group_id: group_id }
    end
  end
  rats.flatten.tqdm.each { |rat_attrs| Rat.create(rat_attrs) }
end

def create_charges
  charges = YAML.load_file('data/charges.yml')
  charges.tqdm(leave: true, desc: 'Importing Charges').each do |charge|
    Charge.create(charge)
  end
end

def create_dogma_attribute_types
  dogma_attribute_types = YAML.load_file('data/dogma_attribute_types.yml')
  dogma_attribute_types.tqdm(leave: true, desc: 'Importing Dogma Attribute Types').each do |dogma_attribute_type|
    DogmaAttributeType.create(dogma_attribute_type)
  end
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
