require 'uri'

class Params
  def initialize(req, route_params)
    raise "Error: route_params not a hash" unless route_params.is_a?(Hash)
    @params = route_params
    query_params = URI.decode_ww_form(req.query_string)
    query_params.each do |qpar|
      raise "Error: query_param not a pair" unless qpar.length == 2
      @params[qpar.first] = @params[qpar.last]
    end
  end

  def [](key)
  end

  def to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
  end

  def parse_key(key)
  end
end
