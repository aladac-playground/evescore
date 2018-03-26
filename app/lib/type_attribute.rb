# frozen_string_literal: true

class TypeAttribute < OpenStruct
  include ActionView::Helpers::NumberHelper

  NAME_TO_PRESENTED = [
    { pattern: /range/i, unit: 'm', value_as: :number_with_delimiter, divide_by: 1, process_value: :to_i },
    { pattern: /duration/i, unit: 's', value_as: :number_with_delimiter, divide_by: 1000, process_value: :to_f },
    { pattern: /bonus/i, unit: '%', value_as: :number_with_delimiter, divide_by: 1, process_value: :to_i },
    { pattern: /neutralization amount/i, unit: 'GJ', value_as: :number_with_delimiter, divide_by: 1, process_value: :to_i }
  ].freeze

  def presented_hash
    NAME_TO_PRESENTED.each do |hash|
      return hash if display_name.match?(hash[:pattern])
    end
  end

  def presented_value
    val = send(presented_hash[:value_as], (value / presented_hash[:divide_by]).send(presented_hash[:process_value]))
    return "#{val} #{presented_hash[:unit]}"
  rescue TypeError
    value
  end

  def to_helper_attribute
    {
      name: display_name,
      value: presented_value
    }
  end
end
