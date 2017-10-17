# frozen_string_literal: true

desc 'Import EVE SDE and API data'
task import: :environment do
  agents = YAML.load_file('data/agtAgents.yaml')
  divisions = YAML.load_file('data/crpNPCDivisions.yaml')
  factions = YAML.load_file('data/chrFactions.yaml')
  agent_ids = []
  corp_ids = []
  agents.with_progress(desc: 'Parsing Agents from file').each do |agent|
    agent = OpenStruct.new agent
    agent_ids.push agent.agentID
    corp_ids.push agent.corporationID
  end

  agents_api = []
  agent_ids.with_progress(desc: 'Getting Agent names from API').each_slice(1000) do |slice|
    agents_api += ESI::UniverseApi.new.post_universe_names slice
  end

  corps = []
  corp_ids.uniq.with_progress(desc: 'Getting Corporation names from API').each_slice(1000) do |slice|
    corps += ESI::UniverseApi.new.post_universe_names slice
  end
  create_agents(agents, agents_api, divisions, corps)
  create_factions(factions)
end

def create_agents(agents, agents_api, divisions, corps)
  agents.with_progress(desc: 'Creating Agents in Mongo').each do |agent|
    agent = OpenStruct.new agent
    corp(corps, agent).agents.where(id: agent.agentID, name: agent_name(agents_api, agent), division: division_name(divisions, agent), level: agent.level).first_or_create
  end
end

def corp(corps, agent)
  Corporation.where(id: agent.corporationID, name: corp_name(corps, agent), npc: true).first_or_create
end

def corp_name(corps, agent)
  corps.select { |c| c.id == agent.corporationID }.first.name
end

def agent_name(agents_api, agent)
  agents_api.select { |a| a.id == agent.agentID }.first.name
end

def division_name(divisions, agent)
  divisions.select { |d| d['divisionID'] == agent.divisionID }.first['divisionName']
end

def create_factions(factions)
  factions.with_progress(desc: 'Creating Factions in Mongo').each do |faction|
    faction = OpenStruct.new faction
    Faction.where(name: faction.factionName, corporation_id: faction.corporationID).first_or_create
  end
end
