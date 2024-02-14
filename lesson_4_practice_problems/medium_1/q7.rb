# How could you change the method name so that it is more clear and less repetitive?
class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def light_status
    "I have a brightness level of #{brightness} and a color of #{color}"
  end

end

# A: Change #light_status to #status. Generally, prefer omitting the name of the 
#   class from method names.
# eg. light = Light.new
#     light.status is more readable and less repetitive than light.light_status