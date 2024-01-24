# Module for #class_of method
# - Converts a string or symbol to a constant (Class) name.

module ClassConverter
  def class_of(value)
    begin
      Object.const_get(value)
    rescue NameError
      nil
    end    
  end
end