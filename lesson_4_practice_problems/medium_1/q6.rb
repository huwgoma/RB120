# Given the following two implementations of the Computer class:
class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

# and 

class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    self.template
  end
end

# What is the difference in the way the code works?

# A: There is no difference between the two implementations. 
#   In the first implementation, the #show_template method simply calls the getter
#     method `template`, returning the value referenced by @template.
#   In the second implementation, the #show_template method also calls the getter 
#     method `template`. The `self.template` syntax explicitly clarifies that we
#     are calling an instance method (`template`) on the current Computer object
#     (`self`); however, this is a redundant `self`, as instance methods are already
#     implicitly called on `self`.
