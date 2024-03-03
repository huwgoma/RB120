# Card Class
class Card
  attr_reader :suit, :face, :value

  def initialize(suit, face)
    @suit = suit
    @face = face
    @value = calculate_value
  end

  def ace?
    face == 'Ace'
  end

  private

  def calculate_value
    case face
    when 'Jack', 'Queen', 'King' then 10
    when 'Ace'                   then [1, 11]
    else                              face.to_i
    end
  end
end