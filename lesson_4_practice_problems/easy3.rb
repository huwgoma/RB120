# 1) Given the following code:
# class Greeting
#   def greet(message)
#     puts message
#   end
# end

# class Hello < Greeting
#   def hi
#     greet("Hello")
#   end
# end

# class Goodbye < Greeting
#   def bye
#     greet("Goodbye")
#   end
# end
# What happens in each case?

# hello = Hello.new
# hello.hi
# A: "Hello" will be output. 

# hello = Hello.new
# hello.bye
# A: An undefined method error will be raised.

# hello = Hello.new
# hello.greet
# A: An argument error (expected 1, received 0) will be raised.

# hello = Hello.new
# hello.greet("Goodbye")
# A: 'Goodbye' will be output.

# Hello.hi
# A: An undefined method error will be raised.



# 2) How would you fix the NoMethodError from calling Hello.hi in the previous 
#   question?
# A: Define a new class method ::hi in either Hello or Greeting
# class Greeting
#   def greet(msg)
#     puts msg
#   end
# end

# class Hello < Greeting
#   def self.hi
#     Greeting.new.greet("Hello") 
      # Feels weird, but we can't just call Hello.greet because #greet is an
      # instance method.
#   end
# end

# Hello.hi



# 3) How do we create two different instances of this class with separate names
#   and ages?
# A: Instantiate two AngryCat objects; their names and ages will be separated, 
#   even if the values are the same.

# class AngryCat
#   def initialize(age, name)
#     @age  = age
#     @name = name
#   end

#   def age
#     puts @age
#   end

#   def name
#     puts @name
#   end

#   def hiss
#     puts "Hisssss!!!"
#   end
# end

# cat1 = AngryCat.new(10, 'Angy')
# cat2 = AngryCat.new(10, 'Angy') 
# These two cats have distinct names and ages, even though the values are the 
# same.



# 4) If we created a new instance of the Cat class and called to_s, we would get
#   something like "#<Cat:0x007....>". How would we change the #to_s output to
#   return "I am a tabby cat"? (if @type was 'tabby')
# A: Define an overriding Cat#to_s method.
# class Cat
#   def initialize(type)
#     @type = type
#   end

#   def to_s
#     "I am a #{@type} cat"
#   end
# end

# p Cat.new('tabby').to_s



# 5) Given the following Television class, what would happen with the given
#   code invocations?
# class Television
#   def self.manufacturer
#     # method logic
#   end

#   def model
#     # method logic
#   end
# end

# tv = Television.new       # Create a new TV object
# tv.manufacturer           # Undefined method error (::manufacturer is a class method)
# tv.model                  # Return whatever TV#model returns

# Television.manufacturer   # Return whatever TV::manufacturer returns
# Television.model          # Undefined method error (#model is an instance method)



# 6) In the make_one_year_older method, we have used `self`. How could we
#   implement this method in a way where we don't have to use the `self` prefix?
# A: Reference the @age instance variable directly
#     eg. @age += 1
# class Cat
#   attr_accessor :type, :age

#   def initialize(type)
#     @type = type
#     @age  = 0
#   end

#   def make_one_year_older
#     @age += 1
#   end
# end

# cat = Cat.new('tabby')
# cat.make_one_year_older
# p cat.age



# 7) What can be removed from this class without losing any functionality?
# A: The explicit return in ::information
# class Light
#   attr_accessor :brightness, :color

#   def initialize(brightness, color)
#     @brightness = brightness
#     @color = color
#   end

#   def self.information
#     return "I want to turn on the light with a brightness level of super high and a color of green"
#   end
# end

