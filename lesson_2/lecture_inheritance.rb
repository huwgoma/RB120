# 1) Given this class:
# class Dog
#   def speak
#     'bark!'
#   end

#   def swim
#     'swimming!'
#   end
# end

# # teddy = Dog.new
# # puts teddy.speak           # => "bark!"
# # puts teddy.swim           # => "swimming!"

# # One problem is that different breeds of dogs have different behaviors. 
# # For example, bulldogs cannot swim, but all other dogs can.
# # Create a subclass from Dog called Bulldog that overrides Dog#swim, returning
# #   a string that says "can't swim!"

# class Bulldog < Dog
#   def swim
#     "can't swim!"
#   end
# end

# bulldog = Bulldog.new
# puts bulldog.swim #=> can't swim!


# 2) Create another class called Cat, which can do everything a Dog can, 
#     except swim or fetch. Assume the shared methods do the same thing.

class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

class Cat < Pet
  def speak
    'meow!'
  end
end


# 3) Map the class hierarchy from step #2
#       Pet
#      /   \
#    Dog   Cat
#     |
#  Bulldog

# Pet: run, jump 
#   Dog: speak, swim, fetch
#     Bulldog: swim
#   Cat: speak


# 4) What is the method lookup path and how is it important?
# The method lookup path describes the order in which Ruby searches for a method 
#   definition to use when a method is invoked. The order goes Class -> Module(s)
#     (last->first) -> Superclass -> Superclass module(s) -> etc... -> BasicObject

# The method lookup path is important because it determines which implementation of 
#   a method will be used, whenever a method is invoked.