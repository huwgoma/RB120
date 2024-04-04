class Pokemon
  self #=> Encapsulating Class (Pokemon)

  # def Pokemon.base_stats
  def self.base_stats
    self #=> Calling Class 
  end

  def update_name(new_name)
    self #=> Calling Object

    self.name = new_name
  end
end