require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/rails_lite.rb'
require 'debugger'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
server = WEBrick::HTTPServer.new :Port => 8080 # :Port, NOT :port
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go
    #render_content("hello world!", "text/html")

    # after you have template rendering, uncomment:
    #render :show

     #after you have sessions going, uncomment:
     session["count"] ||= 0
     session["count"] +=  1 unless @req.path == "/favicon.ico"
     render :counting_show
  end
end

server.mount_proc '/' do |req, res|
  MyController.new(req, res).go
end

server.mount_proc '/echo' do |req, res|
  res.content_type = "text/text"
  res.body = req.path
end

server.mount_proc '/action' do |req, res|
  MyController.new(req, res).render("show")
end

server.mount_proc '/redir' do |req, res|
  MyController.new(req, res).redirect_to("http://www.yahoo.com")
end

server.start
