class Pokemon
  def self.what_is_self
    self
  end
end

class Pikachu < Pokemon
end

p Pikachu.what_is_self