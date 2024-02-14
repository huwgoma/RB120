# Create a class called Greeting with an instance method, #greet - takes a string 
#   and prints that string to the terminal.

# Then create 2 other classes derived from Greeting: one called Hello, and one 
#   called Goodbye. 
#   Hello should have a #hi method - no arguments, prints "Hello"
#   Goodbye should have a #bye method - no arguments, prints Goodbye
#   - Use Greeting#greet to implement #hi and #bye; do not call puts in Hello or
#     Goodbye.

class Greeting
  def greet(str)
    puts str
  end
end

class Hello < Greeting
  def hi
    greet('Hello')
  end
end

class Goodbye < Greeting
  def bye
    greet('Goodbye')
  end
end

Greeting.new.greet('aaa') # aaa
Hello.new.hi              # Hello
Goodbye.new.bye           # Goodbye