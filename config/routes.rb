# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/index'
  get 'character/:character_id', to: 'welcome#character_profile', as: :character_profile
  get 'character/:character_id/earnings', to: 'welcome#earnings', as: :character_earnings
  delete 'character/:character_id/destroy', to: 'welcome#destroy', as: :character_destroy

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
