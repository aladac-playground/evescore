# frozen_string_literal: true

desc 'Import EVE SDE and API data'
task import: :environment do
  Corporation.delete_all
  Agent.delete_all
  Faction.delete_all
  create_corps
  create_agents
  create_factions
end

def create_agents
  agents = YAML.load_file('data/agents.yml')
  agents.tqdm(leave: true, desc: 'Importing Mission Agents').each { |agent|
    Agent.create(agent)
  }
end

def create_corps
  corps = YAML.load_file('data/corporations.yml')
  corps.tqdm(leave: true, desc: 'Importing NPC Corporations').each { |corp|
    Corporation.create(corp)
  }
end

def create_factions
  factions = YAML.load_file('data/factions.yml')
  factions.tqdm(leave: true, desc: 'Importing Factions').each { |faction|
    Faction.create(faction)
  }
end