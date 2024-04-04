# The following is a short description of an application that lets a customer place an order for a meal:

# - A meal always has three meal items: a burger, a side, and drink.
# - For each meal item, the customer must choose an option.
# - The application must compute the total cost of the order.

# 1. Identify the nouns and verbs we need in order to model our classes and methods.
# 2. Create an outline in code (a spike) of the structure of this application.
# 3. Place methods in the appropriate classes to correspond with various verbs.



require 'pry'

class Order
  attr_reader :burger, :side, :drink

  def initialize(burger, side, drink)
    @burger, @side, @drink = burger, side, drink
  end

  def price
    [burger, side, drink].sum(&:price)
    # Add up costs of burger/side/drink
  end

  def to_s
    "#{burger}, #{side}, & #{drink}"
  end
  
end

class MealItem
  attr_reader :option, :price

  def initialize(option)
    @option = option
    @price = self.class::OPTIONS[option]
  end

  def to_s
    "#{option}"
  end
end

class Burger < MealItem
  OPTIONS = {
    'cheeseburger' => 3.29,
    'hamburger'     => 3.39
  }
end

class Side < MealItem
  OPTIONS = {
    'fries' => 1.29,
    'hashbrown' => 2.29
  }
end

class Drink < MealItem
  OPTIONS = { 
    'coke' => 0.99,
    'water' => 0.29
  }
end

class Customer 
  def choose_item(item_type)
    options = item_type::OPTIONS.keys

    puts "Please choose a #{item_type}:"
    puts options

    loop do
      choice = gets.chomp.downcase
      return choice if options.include?(choice)
      puts "Invalid choice!"
    end
  end
end

# Engine class
class MealOrderApplication
  attr_reader :order, :customer

  def initialize
    @customer = Customer.new # choose a name or something
    @order = nil
  end
  
  def place_order
    # Iterate through meal items
    meal_items = [Burger, Side, Drink].each_with_object([]) do |item_type, choices|
      choices << item_type.new(customer.choose_item(item_type))
    end

    # Ask customer to choose an option for burgers/sides/drinks
    # Then create a new order with those options
    order = Order.new(*meal_items)
    
    puts "Order placed! Your order contains a #{order}, and will cost #{order.price}."
  end
end

MealOrderApplication.new.place_order