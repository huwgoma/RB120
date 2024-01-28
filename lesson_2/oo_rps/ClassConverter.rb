# Convert a String or Symbol to the corresponding constant,
# or nil if that constant is undefined.
module ClassConverter
  def class_of(value)
    begin
      Object.const_get(value)
    rescue NameError
      nil
    end    
  end
end