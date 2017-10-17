# frozen_string_literal: true

class String
  def number?
    true if Float(self)
  rescue ArgumentError
    false
  end

  def i?
    /\A[-+]?\d+\z/ =~ self
  end
end
