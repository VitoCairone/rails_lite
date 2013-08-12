require 'json'
require 'webrick'

class Session
  def initialize(req)
    req.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app"
        @cookie_val = JSON.parse(cookie.value)
        raise "Error: Cookie is not a hash" unless @cookie_val.is_a?(Hash)
        return
      end
    end
    @cookie_val = {}
  end

  def [](key)
    @cookie_val[key]
  end

  def []=(key, val)
    @cookie_val[key] = val
  end

  def store_session(res)
    found_mine = false

    res.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app"
        cookie.value = @cookie_val.to_json
        found_mine = true
      end
      cookie
    end

    unless found_mine
      res.cookies << WEBrick::Cookie.new("_rails_lite_app", @cookie_val.to_json)
    end
  end
end
