# 1) What is the result of executing the following code?
# class Oracle
#   def predict_the_future
#     "You will " + choices.sample
#   end

#   def choices
#     ["eat a nice lunch", "take a nap soon", "stay at work late"]
#   end
# end

# oracle = Oracle.new
# p oracle.predict_the_future

# A: This code will return a string containing "You will ", concatenated to
#   one of 3 possible endings - "eat a nice lunch", "take a nap soon", or
#   "stay at work late"



# 2) What is the result of executing the following code?
# class Oracle
#   def predict_the_future
#     "You will " + choices.sample
#   end

#   def choices
#     ["eat a nice lunch", "take a nap soon", "stay at work late"]
#   end
# end

# class RoadTrip < Oracle
#   def choices
#     ["visit Vegas", "fly to Fiji", "romp in Rome"]
#   end
# end

# trip = RoadTrip.new
# p trip.predict_the_future

# A: This code will return a string containing "You will ", concatenated to one 
#   of the 3 possible travel destination strings in the array returned by 
#   RoadTrip#choices.
#  Because the object calling #predict_the_future is a RoadTrip object, Ruby will
#  always start in the RoadTrip class when it tries to find a method definition.



# 3) How do you find where Ruby will look for a method when it is called? How can
#   you find an object's ancestors?
# A: Call the #ancestors method on the object's class (eg. orange.class.ancestors)
# module Taste
#   def flavor(flavor)
#     puts "#{flavor}"
#   end
# end

# class Orange
#   include Taste
# end

# class HotSauce
#   include Taste
# end
# What is the lookup chain for Orange and HotSauce?
# Orange > Taste > Object > Kernel > BasicObject
# HotSauce > Taste > Object > Kernel > BasicObject



# 4) How can you simplify this class and remove 2 methods from the class definition
#   without losing any functionality?
# A: Define setters and getters for @type using attr_accessor. Also remove the 
#   direct instance variable reference in #describe_type (referencing instance
#   variables using the getter method is standard practice)
# class BeesWax
#   attr_accessor :type

#   def initialize(type)
#     @type = type
#   end

#   def describe_type
#     puts "I am a #{type} of Bees Wax"
#   end
# end



# 5) What are the different types of variables below? How do you know which is 
#   which?
# excited_dog = "excited dog"
#   - This is a local variable, indicated by the lowercase naming.
# @excited_dog = "excited dog"
#   - This is an instance variable, indicated by the @ prefix.
# @@excited_dog = "excited dog"
#   - This is a class variable, indicated by the @@ prefix.



# 6) Which method is a class method, if any? How do you know? How would you call it?
# A: The ::manufacturer method is a class method, indicated by the self.method_name
#   syntax. The self in this case refers to the class itself (Television); the method
#   is therefore defined on the class itself. We would call this method by calling
#   it on the class (eg. Television.manufacturer) 

# class Television
#   def self.manufacturer
#     # method logic
#   end

#   def model
#     # method logic
#   end
# end



# 7) What does the @@cats_count variable do? What code would you need to write to
#   test this theory?
# A: The @@cats_count variable keeps track of the number of Cat instances that have
#   been instantiated. Every time a Cat object is created and the Cat#initialize
#   method is called, @@cats_count is incremented by 1 within #initialize.
#   We can test this by instantiating a number of Cat objects and checking the
#   value of @@cats (using the ::cats_count method) between each instantiation.
#     eg. 3.times do 
#           Cat.new('tabby')
#           puts Cat.cats_count
#         end
# class Cat
#   @@cats_count = 0

#   def initialize(type)
#     @type = type
#     @age  = 0
#     @@cats_count += 1
#   end

#   def self.cats_count
#     @@cats_count
#   end
# end



# 8) What can we add to the Bingo class to allow it access to the #play method
#   from Game?
# A: Subclass Bingo from Game (ie. Bingo < Game)
# class Game
#   def play
#     "Start the game!"
#   end
# end

# class Bingo < Game
#   def rules_of_play
#     #rules of play
#   end
# end



# 9) What would happen if we added a #play method to Bingo? 
# A: When #play is called on an instance of Bingo, the Bingo#play method would 
#   be called instead of the Game#play method. This is because Ruby checks the 
#   class of the calling object first whenever it tries to find a method definition.

# class Game
#   def play
#     "Start the game!"
#   end
# end

# class Bingo < Game
#   def rules_of_play
#     #rules of play
#   end

#   def play; end
# end



# 10) What are the benefits of using Object Oriented Programming? 
# - OOP allows you to model your program based on tangible real-life concepts,
#   representing them as classes, modules, and objects.
# - It's (subjectively) easier to think about objects 'talking' to each other to 
#   get some task done
# - It keeps your code more organized; refactoring is often easier since everything
#   is compartmentalized
