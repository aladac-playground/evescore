# frozen_string_literal: true

desc 'Import EVE SDE and API data'
task import: :environment do
  agents = YAML.load_file('data/agtAgents.yaml')
  divisions = YAML.load_file('data/crpNPCDivisions.yaml')
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

  agents.with_progress(desc: 'Creating Agents in Mongo').each do |agent|
    agent = OpenStruct.new agent
    corp = Corporation.where(id: agent.corporationID, name: corps.select { |c| c.id == agent.corporationID }.first.name, npc: true).first_or_create
    agent_name = agents_api.select { |a| a.id == agent.agentID }.first.name
    division_name = divisions.select { |d| d['divisionID'] == agent.divisionID }.first['divisionName']
    corp.agents.where(id: agent.agentID, name: agent_name, division: division_name, level: agent.level).first_or_create
  end
end
