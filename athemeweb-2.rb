#!/usr/bin/env ruby

require 'sinatra'
require 'haml'

get '/' do
  haml :placeholder, :format => :html5
end
