class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    matchdata = self.pattern.match(req.path)
    matchdata && (req.request_method.downcase.to_sym == self.http_method)
  end

  def run(req, res)
    matchdata = pattern.match(req.path)
    route_params = {}
    matchdata.names.each { |name| route_params[name] = matchdata[name] }

    controller_class.new(req, res, route_params).invoke_action(self.action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  def match(req)
    self.routes.find { |route| route.matches?(req) }
  end

  def run(req, res)
    route = self.match(req)
    if route.nil?
      res.status = 404
      return
    end
    route.run(req, res)
  end
end
