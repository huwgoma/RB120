# Based on the prior vehicles question, we must now track a motorboat.
# Motorboats have a single propeller and hull, but otherwise behave similar to a 
#   catamaran; creators of Motorboat objects don't need to specify the number of
#   hulls or propellers (Default 1).

# Modify the code to accomodate this.

# Motorboat - Subclass Catamaran; when initializing, set num_propellers and 
#   num_hulls to 1


module Movable
  attr_accessor :speed, :heading
  attr_writer :fuel_efficiency, :fuel_capacity

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

# Boats
class SeaVehicle
  include Movable
  attr_reader :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    @num_propellers = num_propellers
    @num_hulls = num_hulls
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end
end

class Catamaran < SeaVehicle
end

class Motorboat < SeaVehicle
  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    # num_propellers and num_hulls are both 1
    super(1, 1, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end