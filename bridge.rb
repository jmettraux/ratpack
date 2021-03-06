#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'

use Rack::ShowExceptions

configure do
  RATPACK_ROOT = File.dirname(__FILE__) unless defined?( RATPACK_ROOT )
  require 'lib/ratpack'
  Ratpack::Application.instance(
    :jabber_id => 'ratpack@devbox',
    :password => 'secret',
    :contacts => ['kenneth@devbox']
  )
  trap(:INT) do
    Ratpack::Application.instance.shutdown!
  end
end

get '/' do
  '<html><head><title>Talk!</title></head><body><h1>Talk!</h1></body></html>'
end

post '/message' do
  to = params[:to]
  message = params[:message]

  Ratpack::Application.instance.message( to, message ).to_xml
end

post '/broadcast' do
  to = params['recipients[]']
  message = params[:message]

  Ratpack::Application.instance.broadcast( message, to ).to_xml
end

post '/pool' do
  to = params[:pool]
  message = params[:message]

  Ratpack::Application.instance.pool( to, message ).to_xml
end
