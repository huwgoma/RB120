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
    when 'Ace'                   then nil
    # Ace value can't be determined at this point
    else                              face.to_i
    end
  end
end

class Ace < Card
  VALUES = [1, 11]

  def set_value(minmax)
    self.value = case minmax
                 when :min then VALUES.min
                 when :max then VALUES.max
                 end
  end

  private 

  attr_writer :value
end