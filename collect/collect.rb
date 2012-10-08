require 'rubygems'
require 'rufus/scheduler'
require 'mongo'
require 'bson'
require 'json'

site = ARGV[0] || 'localhost'
interval = ARGV[1] || '15m'
coll = Mongo::Connection.new.db('hars')[site]
puts ARGV.inspect
scheduler = Rufus::Scheduler.start_new

scheduler.every interval do
  har_json_string = IO.popen("phantomjs netsniff.coffee " + site).readlines.join
  yslow = IO.popen('yslow --info basic', 'r+') { |f|
  	f.puts har_json_string
  	f.close_write
  	f.read
  }

  har = JSON.parse har_json_string
  har['yslow'] = JSON.parse yslow
  coll.insert(har)
end

scheduler.join
