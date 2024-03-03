# Card Class
class Card
  attr_reader :suit, :face, :value

  def initialize(suit, face)
    @suit = suit
    @face = face
    @value = calculate_value
  end

  def ace?
    self.class == Ace
  end

  private

  def calculate_value
    case face
    when 'Jack', 'Queen', 'King' then 10
    #when 'Ace'                   then [1, 11]
    else                              face.to_i
    end
  end
end

class Ace < Card
  VALUES = [1, 11]

  def calculate_value
    VALUES
  end

  def set_value(minmax)
    self.value = VALUES.public_send(minmax)
  end

  private 

  attr_writer :value
end

# Set value to either VALUES.min or VALUES.max, depending on ? 
# 