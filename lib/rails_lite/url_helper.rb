require 'debugger'

module UrlHelper

  def add_url_helper(name)
    strproc = Proc.new { "http://localhost:8080/#{name}" }
    self.class.send(:define_method, "#{name}_url".to_sym, &strproc)
  end
end