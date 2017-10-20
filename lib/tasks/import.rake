# frozen_string_literal: true

namespace :import do
  desc 'Import all EVE SDE and API data'
  task all: :environment do
    Corporation.delete_all(npc: true)
    Agent.delete_all
    Faction.delete_all
    create_corps
    create_agents
    create_factions
  end
  desc 'Import NPC corporations from EVE SDE and API data'
  task corps: :environment do
    Corporation.delete_all(npc: true)
    create_corps
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
