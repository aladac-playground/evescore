# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/index'
  get 'characters', to: 'characters#index', as: :characters
  get 'characters/:character_id', to: 'characters#profile', as: :character_profile
  get 'characters/:character_id/earnings', to: 'characters#earnings', as: :character_earnings
  get 'characters/:character_id/ticks', to: 'characters#ticks', as: :character_ticks
  get 'characters/:character_id/rats', to: 'characters#rats', as: :character_rats
  get 'characters/:character_id/journal', to: 'characters#journal', as: :character_journal
  delete 'characters/:character_id/destroy', to: 'characters#destroy', as: :character_destroy
  patch 'characters/:character_id/display_option', to: 'characters#display_option', as: :character
  get 'ticks', to: 'welcome#ticks', as: :global_ticks
  get 'average_ticks', to: 'welcome#average_ticks', as: :average_ticks
  get 'isk', to: 'welcome#isk', as: :isk

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
