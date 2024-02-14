# Given this code:

class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    quantity = updated_count if updated_count >= 0
  end
end

# One way of fixing the #update_quantity method is to change attr_reader to
# attr_accessor, and changing quantity to self.quantity.
# Is there anything wrong with fixing it this way?

# A: Changing attr_reader to attr_accessor will expose public setter methods for 
#   both @quantity and @product name.
#   - This allows the public to bypass the #update_quantity method and directly 
#     set @quantity's value using quantity=(), which we may not want (validation
#     is bypassed)
#   - The same problem also applies to the @product_name variable.
#   - We can fix this by separately defining the writer method for @quantity and
#     making it private.

# eg.
# class InvoiceEntry
#   attr_reader :quantity, :product_name

#   def initialize(product_name, number_purchased)
#     @quantity = number_purchased
#     @product_name = product_name
#   end

#   def update_quantity(updated_count)
#     self.quantity = updated_count if updated_count >= 0
#   end

#   private 

#   attr_writer :quantity
# end