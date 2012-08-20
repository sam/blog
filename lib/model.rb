module Model
  
  def self.included(target)
    target.extend ClassMethods
  end
  
  module ClassMethods
    def db
      @db ||= self::Db.new
    end
    
    def db=(value)
      @db = value
    end
    
    def typecast_time(value)
      value.blank? ? nil : (Chronic::parse(value) || Time::parse(value))
    end
  end
  
  def initialize(values = nil)
    if values
      @values = values
      values.each do |k,v|
        if self.class.method_defined?("#{k}=")
          send("#{k}=", v)
        else
          if k =~ /\_at$/
            instance_variable_set("@#{k}", self.class.typecast_time(v))
          else
            instance_variable_set("@#{k}", v)
          end
        end
      end
    end
  end
  
  def save
    self.class.db.save(self)
  end
  
  def method_missing(name, *args, &b)
    if name =~ /\?$/
      !!instance_variable_get("@#{name.to_s.sub(/\?$/, "")}")
    elsif name =~ /\=$/
      instance_variable_set("@#{name.to_s.sub(/\=$/, "")}", *args)
    else
      instance_variable_get("@#{name}")
    end
  end
  
  def inspect
    "#<#{self.class}: #{to_hash.map { |k,v| "#{k}=#{v.inspect}" }.join(", ") || "EMPTY"}>"
  end
  
  def to_hash
    (@values || {}).inject({}) do |h,pair|
      h[pair[0]] = send(pair[0]); h
    end
  end
end