# 1) Given the following usage of the Person class, code the class definition:
# class Person
#   attr_accessor :name
  
#   def initialize(name)
#     @name = name
#   end
# end

# bob = Person.new('bob')
# p bob.name                  # => 'bob'
# bob.name = 'Robert'
# p bob.name                  # => 'Robert'


# 2) Modify the Person class to facilitate the following methods. Note that there 
#    is no setter method for @name (name=)
# class Person
#   attr_accessor :first_name, :last_name
  
#   def initialize(full_name)
#     @first_name, @last_name = full_name.split.push('')
#   end

#   def name
#     "#{first_name} #{last_name}".strip
#   end
# end

# bob = Person.new('Robert')
# p bob.name                  # => 'Robert'
# p bob.first_name            # => 'Robert'
# p bob.last_name             # => ''
# bob.last_name = 'Smith'
# p bob.name                  # => 'Robert Smith'


# 3) Create a smart name= setter method that takes a string and sets @first_name
#    and @last_name appropriately.
#    - If the given string contains two words (space separated), set first name 
#      to the first word and last name to the second
#    - If the given string only contains one word, set first name to the word

# class Person
#   attr_accessor :first_name, :last_name
  
#   def initialize(full_name)
#     set_names(full_name)
#   end

#   def name
#     "#{first_name} #{last_name}".strip
#   end

#   def name=(name)
#     set_names(name)
#   end

#   private 

#   def set_names(name)
#     self.first_name, self.last_name = name.split.push('')
#   end
# end

# bob = Person.new('Robert')
# p bob.name                  # => 'Robert'
# p bob.first_name            # => 'Robert'
# p bob.last_name             # => ''
# bob.last_name = 'Smith'
# p bob.name                  # => 'Robert Smith'

# bob.name = "John Adams"
# p bob.first_name            # => 'John'
# p bob.last_name             # => 'Adams'

# bob.name = 'Stark'
# p bob.first_name            # => 'Stark'
# p bob.last_name             # => ''


# 4) If we're trying to determine whether two people have the same name, how 
#    can we compare the two Person objects?
class Person
  attr_accessor :first_name, :last_name
  
  def initialize(full_name)
    set_names(full_name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(name)
    set_names(name)
  end

  def to_s
    name
  end

  private 

  def set_names(name)
    self.first_name, self.last_name = name.split.push('')
  end
end
# bob = Person.new('Robert Smith')
# rob = Person.new('Robert Smith')
# p bob.name == rob.name

# If we compare bob == rob, it will return false. This is because the #== method 
#   being used is BasicObject's #== method, which returns true only if the two 
#   objects are the same object (ID).
# Comparing bob.name to rob.name will yield different behavior: even though bob's
#   'Robert Smith' and rob's 'Robert Smith' are different string objects, it is 
#   the String#== method that is being used, which only compares the *values* of
#   the two strings.


# 5) What does the below code print out?
# bob = Person.new("Robert Smith")
# puts "The person's name is: #{bob}"

# This code will output the following string: 
#   "The person's name is: #<Person:0x000...>"
#   This occurs because the #to_s method is automatically called on the `bob` 
#   object, as part of string interpolation. Since the Person class does not 
#   provide its own implementation of #to_s, Object#to_s (which returns a string
#   representation of the object) is used instead.

# If we added a to_s method to Person:
# class Person
#   # ... rest of class omitted for brevity

#   def to_s
#     name
#   end
# end

# What will this code output now?
bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"
# This code will now output "The person's name is: Robert Smith"
#   When #to_s is called on `bob`, Ruby will first look in the Person class for
#    a #to_s method, which it finds; Person#to_s simply calls the Person#name 
#    method, which returns a string containing the person's first name and last name.
