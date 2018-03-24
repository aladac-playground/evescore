# frozen_string_literal: true

class SearchController < ApplicationController
  def search
    head(:ok) && return if params[:query].blank?
    @rats = Rat.where(name: /#{params[:query]}/i).map { |r| { id: r.id, name: r.name } }
    render json: @rats
  end
end
