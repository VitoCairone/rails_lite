require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  # def inspect
  #   "Controller #{self.object_id}"
  # end

  def initialize(req, res, route_params = {})
    raise "Double Render Error in initialize" if already_rendered?
    @already_rendered = false
    @req = req
    @res = res
    @params = Params.new(@req, route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    @already_rendered # boolean attribute
  end

  def redirect_to(url)
    raise "Double Render Error in redirect_to" if already_rendered?
    session.store_session(@res)
    @res.status = 302
    @res['location'] = url
    @already_rendered = true
  end

  def render_content(body, content_type)
    raise "Double Render Error in render_content" if already_rendered?
    session.store_session(@res)
    @res.content_type = content_type
    @res.body = body
    @already_rendered = true
  end

  def render(action_name)
    controller_name = self.class.to_s.underscore
    file_path = "views/#{controller_name}/#{action_name}.html.erb"
    # TODO: Handle file-does-not-exit error here
    file_content = File.read(file_path)
    puts "file_content => #{file_content}"
    foo = 13
    controller_binding = binding
    template = ERB.new(file_content).result(controller_binding)
    render_content(template, "text/text")
   end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_rendered?
  end
end
