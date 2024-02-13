# 1) Which of the following are objects in Ruby? 
#   If they are objects, how can you find their class?
# A: All of them are objects; we can find their class using the #class method.
#   true.class => TrueClass                
#   "hello".class => String
#   [1, 2, 3, "happy days"].class => Array
#   142.class => Integer



# 2) If we have a Car class and a Truck class, and we want to #go_fast, how
#   can we add this behavior using the Speed module? How can you check if your
#   Car or Truck can now go fast?
# A: Mix in the Speed module using `include`.

# module Speed
#   def go_fast
#     puts "I am a #{self.class} and going super fast!"
#   end
# end

# class Car
#   include Speed
  
#   def go_slow
#     puts "I am safe and driving slow."
#   end
# end

# class Truck
#   include Speed
  
#   def go_very_slow
#     puts "I am a heavy truck and like going very slow."
#   end
# end

# Car.new.go_fast   # Check if the car
# Truck.new.go_fast # and truck can go fast



# 3) When we called #go_fast from a Car object, the output includes the 
#   name of the vehicle type.
#     eg. Car.new.go_fast #=> I am a Car and going super fast!
#   How is this done?
# A: The Speed#go_fast method calls the #class method on `self`; in this context,
#    `self` represents the object that called the #go_fast method (which is a 
#     Car object), and the #class method returns the Constant name of that 
#     object's class (Car). #to_s is automatically called on the constant name,
#     due to string interpolation.



# 4) If we have an AngryCat class, how do we create a new instance of this class?
# A: Call ::new on AngryCat (eg. AngryCat.new)

# class AngryCat
#   def hiss
#     puts 'Hiss!!'
#   end
# end

# angry_cat = AngryCat.new



# 5) Which of these two classes would create objects that have an instance 
#   variable? How do you know?
# A: Only the Pizza class would have an instance variable. This is because instance
#   variables are prefixed with @; the Fruit#initialize method only initializes
#   a new *local* variable, `name`, rather than an instance variable `@name`.

# class Fruit
#   def initialize(name)
#     name = name
#   end
# end

# class Pizza
#   def initialize(name)
#     @name = name
#   end
# end



# 6) What is the default return value of #to_s when invoked on an object?
#   Where could you verify this information?
# A: The 'default' Object#to_s method returns a string representation of the object
#   containing the object's class and an encoding of its object ID. We could verify
#   this information in the documentation for Object (https://docs.ruby-lang.org/en/3.3/Object.html#method-i-to_s)



# 7) What does self refer to in #make_one_year_older ?
# class Cat
#   attr_accessor :type, :age

#   def initialize(type)
#     @type = type
#     @age  = 0
#   end

#   def make_one_year_older
#     self.age += 1
#   end
# end

# A: self refers to the -current object-; in this case, it refers to 
#   the instance of the Cat class that invoked #make_one_year_older.
#   self.age tells Ruby to invoke the setter method for the current Cat object's 
#   @age instance variable, setting its new value to its old value + 1.



# 8) What does self refer to in ::cats_count ? 
# ...
# def self.cats_count
# @@cats_count
# end

# A: self refers to the class itself, Cat. 
#   def self.cats_count tells Ruby that we are defining a class method.



# 9) What would we need to call to create a new instance of this class?
# class Bag
#   def initialize(color, material)
#     @color = color
#     @material = material
#   end
# end

# A: We would need to call Bag.new, with 2 arguments - one for the color variable,
#   and one for the material variable (eg. Bag.new('green', 'paper'))