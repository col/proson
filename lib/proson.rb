require 'json'

class Proson

  def initialize(*args)
    super()
    if args[0].is_a? Hash
      parse_hash(args[0])
    else
      parse_json(args[0])
    end
  end

  # Accepts any of the following data types: String, Hash, Array
  # Returns a new instance for a string or hash
  # Returns an array of instances for an array.
  def self.parse(arg)
    if arg.is_a? Hash
      return self.new(arg)
    elsif arg.is_a? Array
      return arg.map { |i| self.parse(i) }
    else
      return self.new(arg.to_s)
    end
  end

  private

  @@json_attributes = []

  def self.json_attr(*args)
    args.each do |arg|
      @@json_attributes << arg
      send(:attr_accessor, arg.to_sym)
    end
  end

  def parse_json(json)
    return if json.to_s.length == 0
    result = JSON.parse(json)
    if result.is_a? Hash
      parse_hash(result)
    else
      raise Exception.new('Invalid argument - Expected json object but got a json array.')
    end
  end

  def parse_hash(hash)
    @@json_attributes.each do |attr|
      value = hash[attr] || hash[attr.to_s]
      self.send("#{attr}=", value) if value
    end
  end

end