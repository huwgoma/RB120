# Card Class
class Card
  attr_reader :suit, :face, :value

  # Custom initializer
  def self.create(suit, face)
    face == 'Ace' ? Ace.new(suit, face) : Card.new(suit, face)
  end

  def initialize(suit, face)
    @suit = suit
    @face = face
    @value = calculate_value
  end

  def ace?
    self.class == Ace
  end

  def to_s
    "#{face} of #{suit}"
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

# Card.create(suit, face)
#   if face == 'Ace' then Ace.new(suit, face)
#   else Card.new(suit, face)
#   
# Create Ace instead of Card if face is Ace