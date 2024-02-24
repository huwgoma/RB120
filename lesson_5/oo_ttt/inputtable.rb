# Module for all input-related methods - Prompt + Validation
module Inputtable

  module Promptable
    def prompt_name
      binding.pry
      puts "What's your name?"
      loop do
        name = gets.chomp.strip
        return name unless name.empty?
  
        puts "You can't have an empty name!"
      end
    end
  end
  
  module Validatable

  end

  

end