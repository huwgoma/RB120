# Ben and Alyssa are creating a vehicle management system. 
# So far, they have two classes, Auto and Motorcycle. They then decide to 
#   extract common behaviors to a superclass, WheeledVehicle.

# class WheeledVehicle
#   attr_accessor :speed, :heading

#   def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
#     @tires = tire_array
#     @fuel_efficiency = km_traveled_per_liter
#     @fuel_capacity = liters_of_fuel_capacity
#   end

#   def tire_pressure(tire_index)
#     @tires[tire_index]
#   end

#   def inflate_tire(tire_index, pressure)
#     @tires[tire_index] = pressure
#   end

#   def range
#     @fuel_capacity * @fuel_efficiency
#   end
# end

# class Auto < WheeledVehicle
#   def initialize
#     # 4 tires are various tire pressures
#     super([30,30,32,32], 50, 25.0)
#   end
# end

# class Motorcycle < WheeledVehicle
#   def initialize
#     # 2 tires are various tire pressures
#     super([20,20], 80, 8.0)
#   end
# end

# Alan then asks them to add a new type of Vehicle - A Catamaran (boat):
# class Catamaran
#   attr_reader :propeller_count, :hull_count
#   attr_accessor :speed, :heading

#   def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
#     # ... code omitted ...
#   end
# end
# Catamarans don't have tires, so it doesn't make sense to subclass it from 
# WheeledVehicles; however, we would still like to keep the fuel efficiency/capacity
# code in a common place.

# Modify the code to do this.

# Classes:
# - Auto (Car)
# - Motorcycle
# * WheeledVehicles (subclass car and motorcycle)
#   b: track tire pressure, inflate tire, track fuel efficiency, calculate range
# - Boat
#   - Not a wheeled vehicle 
#   b: track fuel efficiency, calculate range

# Create a module, Move
# - tracks fuel efficiency and calculates range
# - Also track speed and heading
# - Include in WheeledVehicles and Boat

module Movable
  attr_accessor :speed, :heading
  attr_writer :fuel_efficiency, :fuel_capacity
  # accessor these two? then we can drop the @instance variable references to
  #   getter methods instead

  def range
    @fuel_capacity * @fuel_efficiency
  end

end

class WheeledVehicle
  include Movable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

class Catamaran
  include Movable
  attr_reader :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    # ... code omitted ...
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end
end

wheel = Auto.new
p wheel.range

cat = Catamaran.new(2, 3, 50, 25)
p cat.range