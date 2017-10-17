# frozen_string_literal: true

class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  ## Database authenticatable
  field :email,              type: String, default: ''
  field :encrypted_password, type: String, default: ''

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  has_many :characters

  def character_api
    ESI::CharacterApi.new
  end

  def import_character(omniauth_payload)
    character_id = omniauth_payload['extra']['raw_info']['CharacterID']
    api_character = character_api.get_characters_character_id(character_id)
    credentials = omniauth_payload['credentials']
    character = characters.where(id: character_id, name: api_character.name, corporation_id: api_character.corporation_id).first_or_create
    character.update_tokens(credentials)
  end

  def earnings_by_day
    WalletRecord.user_earnings_by_day(id).map do |b|
      OpenStruct.new(date: b['_id'].to_date, amount: b['amount'])
    end
  end

  def kills_by_bounty
    Kill.user_kills_by_bounty(id).map do |k|
      OpenStruct.new(rat: Rat.find(k['_id']['rat_id']),
                     amount: k['amount'])
    end
  rescue Mongoid::Errors::DocumentNotFound
    []
  end

  def kills_by_faction
    Kill.user_kills_by_faction(id).map do |k|
      OpenStruct.new(faction: Faction.find(k['_id']), amount: k['amount']) if k['_id']
    end.compact
  rescue Mongoid::Errors::DocumentNotFound
    []
  end
end
