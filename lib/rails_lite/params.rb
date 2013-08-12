require 'uri'

class Params
  def initialize(req, route_params)
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

  private
  def grab_params(source)
    return if source.nil?
    src_params = parse_www_encoded_form(source)
    src_params.each do |spar|
      raise "Error: source_param not a pair" unless spar.length == 2
      @params[spar.first] = spar.last
    end
  end

  def parse_www_encoded_form(www_encoded_form)
    return nil if www_encoded_form.nil?
    URI.decode_www_form(www_encoded_form)
  end

  def parse_key(key)

  end
end
