# frozen_string_literal: true

class Character
  include Mongoid::Document
  field :name, type: String
  field :access_token, type: String
  field :refresh_token, type: String
  field :token_expires, type: Time
  belongs_to :corporation, optional: true
  belongs_to :user
  has_many :wallet_records
  has_many :kills

  after_save :create_corporation

  def create_corporation
    Corporation.create_from_api(corporation_id)
  end

  def update_tokens(credentials)
    self.access_token = credentials['token']
    self.refresh_token = credentials['refresh_token']
    self.token_expires = Time.at credentials['expires_at']
    save
  end

  def refresh_token!
    return false if Time.now < token_expires
    self.access_token = refresh_token_request.access_token
    self.refresh_token = refresh_token_request.refresh_token
    self.token_expires = Time.now + refresh_token_request.expires_in
    save
  end

  def refresh_token_request
    request = Typhoeus.post('https://login.eveonline.com/oauth/token', headers: refresh_token_headers, body: refresh_token_body)
    OpenStruct.new(JSON.parse(request.body))
  end

  def refresh_token_headers
    { 'Content-Type' => 'application/json', 'Authorization' => authorization_header }
  end

  def refresh_token_body
    { grant_type: 'refresh_token', refresh_token: refresh_token }.to_json
  end

  def current_access_token
    refresh_token!
    access_token
  end

  def authorization_header
    secrets = OpenStruct.new Rails.application.config_for(:secrets)
    app_id = secrets.eve_api_app_id
    app_secret = secrets.eve_api_app_secret
    auth = Base64.strict_encode64("#{app_id}:#{app_secret}")
    "Basic #{auth}"
  end

  def api_client
    client = ESI::ApiClient.new
    client.config.access_token = current_access_token
    client
  end

  def wallet_api
    ESI::WalletApi.new(api_client)
  end

  def wallet_journal
    wallet_api.get_characters_character_id_wallet_journal(id)
  end

  def import_wallet
    wallet_journal.select { |r| WalletRecord.importable?(r.ref_type) }.each do |wallet_record|
      WalletRecord.create_from_api(id, wallet_record)
    end
  end

  def bounty_by_day
    WalletRecord.bounty_by_day(id).map do |b|
      OpenStruct.new(date: b['_id'].to_date, amount: b['amount'])
    end
  end

  def kills_by_bounty
    Kill.kills_by_bounty(id).map do |k|
      OpenStruct.new(rat: Rat.find(k['_id']['rat_id']),
                     amount: k['amount'])
    end
  end

  def kills_by_faction
    Kill.kills_by_faction(id).map do |k|
      OpenStruct.new(faction: Faction.find(k['_id']), amount: k['amount']) if k['_id']
    end.compact
  end

  def average_tick
    wallet_records.sum(:amount) / wallet_records.count
  rescue ZeroDivisionError
    0
  end

  def total_isk
    wallet_records.sum(:amount)
  end

  def total_kills
    kills.sum(:amount)
  end

  def favourite_faction
    kills_by_faction.first.faction
  rescue NoMethodError
    OpenStruct.new
  end
end
