# Ben asked Alyssa to review the following code:
class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

acc = BankAccount.new(1000)
p acc.positive_balance?

# Alyssa said "you forgot to put the @ before balance in the #positive_balance?"
# method. 
# Ben replied "i'm not missing a @!"
# Who is right? Why?

# A: Ben is right. The attr_reader :balance method gives us access to the getter
#   method for @balance, meaning that anytime we refer to `balance` within the 
#   instance methods of BankAccount (without assignment syntax; 
#   eg. not balance=<value> ), we are calling the `balance` getter method,
#   which returns the value of @balance.