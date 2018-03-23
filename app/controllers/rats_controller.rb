# frozen_string_literal: true

class RatsController < ApplicationController
  def show
    @rat = Rat.find(params[:id].to_i)
    @attributes = @rat.rat_attributes
  rescue Mongoid::Errors::DocumentNotFound
    head :not_found
  end
end
