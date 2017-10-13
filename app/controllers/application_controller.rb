# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  layout :choose_layout

  def choose_layout
    if devise_controller?
      'bare'
    else
      'application'
    end
  end
end
