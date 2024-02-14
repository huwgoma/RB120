# 2) Alan created the following code to keep track of items for a shopping cart
#   application:
class InvoiceEntry
  attr_reader :quantity, :product_name
  attr_writer :quantity

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    @quantity = updated_count if updated_count >= 0
    # or
    # self.quantity = updated_count if updated_count >= 0
  end
end

entry = InvoiceEntry.new('apple', 69)
p entry.quantity # 69
entry.update_quantity(0)
p entry.quantity # 69

# Alyssa spotted a mistake: "This will fail when update_quantity is called".
# How would you address this mistake?

# A: The error is that the value of `@quantity` will not be updated by 
#   #update_quantity. This occurs because Ruby thinks we are initializing and 
#   assigning a local variable `quantity` to `updated_count`, and not the instance
#   variable `@quantity`.
#   - To fix this, we can either:
#     1) Reference the instance variable directly (eg. @quantity = )
#     or 
#     2) Prefix self to quantity (eg. self.quantity), then define a setter method
#     for @quantity. The self.quantity syntax explicitly clarifies that we want
#     to call the quantity=() setter method for the current object's @quantity
#     variable.
