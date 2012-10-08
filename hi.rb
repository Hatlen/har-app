require 'sinatra'
require 'mongo'
require 'bson'
require 'json'
require './api.rb'
require 'time'


#codes = File.open('codes').readlines
#user_name = codes[0].strip
#password = codes[1].strip

#db = Mongo::Connection.new user_name, password
db = Mongo::Connection.new['hars']

get '/api/*' do
	d = GetHars.new(db)
	d.choseColl('http://google.se')
	
	resources = {}

	n = params[:splat][0].to_i
	if not n.integer? or n == 0
		n = 1
	end

	d.getSome(n) do |e|
		begin
			timestamp = Time.parse(e['log']['pages'][0]['startedDateTime']).to_i * 1000
			e['log']['entries'].each do | e |
				url = e['request']['url']
				time = e['time']
				if not resources.has_key? url
					resources[url] = []
				end
				resources[url].push([timestamp, time])
			end
		end
	end
	array = []
	resources.each do |key, values|
		array.push({'key' => key, 'values'=> values})
	end

	JSON.unparse array
end

get '/*' do
	route = params[:splat][0]

	if route = ''
		route = 'index.html'
	end

	route = 'public/' + route
	if File.exists? route
		stream do |out|
			File.open(route).each do | line |
				out << line
			end	
		end
	else
		'The file was not found. Try your psychic powers and guess another url.'
	end
end