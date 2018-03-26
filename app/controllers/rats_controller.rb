# frozen_string_literal: true

class RatsController < ApplicationController
  def show
    @rat = Rat.find(params[:id].to_i)
    @attributes = Rats::Attributes.new(@rat.rat_attributes)
    @missile_attributes = begin
                            Charges::Attributes.new(Charge.find(@attributes.entity_missile_type_id.value.to_i).charge_attributes)
                          rescue StandardError
                            nil
                          end
  rescue Mongoid::Errors::DocumentNotFound
    head :not_found
  end

  def details
    @rat = Rat.find(params[:id].to_i)
    @attributes = Rats::Attributes.new(@rat.rat_attributes)
  end
end
