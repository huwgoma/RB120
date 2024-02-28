# frozen_string_literal: true

# Represents individual squares on a TTT Board
class Square
  attr_reader :value

  INITIAL_VALUE = ' '

  def initialize
    @value = INITIAL_VALUE
  end

  def mark(value)
    self.value = value
  end

  def unmark
    self.value = INITIAL_VALUE
  end

  def empty?
    value == INITIAL_VALUE
  end

  def marked?
    value != INITIAL_VALUE
  end

  private

  attr_writer :value
end
