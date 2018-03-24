# frozen_string_literal: true

module Rats
  class Attributes
    def initialize(array)
      @array = array
    end

    def method_missing(method_name)
      @array.select do |attribute|
        attribute.display_name == method_name.to_s.split('_').map(&:capitalize).join(' ').gsub(/ Em /, ' EM ')
      end.first || super
    end

    def respond_to_missing?
      super
    end
  end
end
