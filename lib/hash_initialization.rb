module HashInitialization
  
  def initialize(values = nil)
    if values
      values.each do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
  
  def method_missing(name, *args, &b)
    if name =~ /\?$/
      !!instance_variable_get("@#{name.sub(/\?$/, "")}")
    else
      instance_variable_get("@#{name}")
    end
  end
  
end