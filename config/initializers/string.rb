class String
  def is_number?
    true if Float(self) rescue false
  end
  
  def is_i?
     /\A[-+]?\d+\z/ === self
  end
end