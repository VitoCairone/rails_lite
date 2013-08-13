require 'uri'

class Params

  def initialize(req, route_params = {})
    raise "Error: route_params not a hash" unless route_params.is_a?(Hash)
    @params = route_params
    grab_params(req.query_string)
    grab_params(req.body)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  #private

  def grab_params(source)
    return if source.nil?
    src_params = parse_www_encoded_form(source)
    src_params.each do |spar|
      raise "Error: src_param is not a pair" unless spar.length == 2
      key_arr = spar.first
      value = spar.last

      here = @params
      key_arr[0..-2].each do |key_lev|
        here[key_lev] ||= {}
        here = here[key_lev]
      end
      here[key_arr[-1]] = value
    end
  end

  def parse_www_encoded_form(www_encoded_form)
    return nil if www_encoded_form.nil?
    pairs = URI.decode_www_form(www_encoded_form)
    pairs.map { |pair| [ parse_key(pair[0]), pair[1] ] }
  end

  def parse_key(key)
    raise "Error: key is not a string in parse_key" unless key.is_a?(String)
    key.gsub("]","").split("[")
  end
end
