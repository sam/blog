## Credit: rails / activesupport / lib / active_support / core_ext / object / blank.rb

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

class NilClass
  def blank?
    true
  end
end

class FalseClass
  def blank?
    true
  end
end

class TrueClass
  def blank?
    false
  end
end

class Array
  alias_method :blank?, :empty?
end

class Hash
  alias_method :blank?, :empty?
end

class String
  def blank?
    self !~ /[^[:space:]]/
  end
end

class Numeric
  def blank?
    false
  end
end