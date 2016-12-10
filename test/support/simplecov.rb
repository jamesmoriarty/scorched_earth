require 'simplecov'


SimpleCov.add_group "Events",      "lib/scorched_earth/event/"
SimpleCov.add_group "Objects",     "lib/scorched_earth/objects/"
SimpleCov.add_group "Services",    "lib/scorched_earth/services/"
SimpleCov.add_group "Subscribers", "lib/scorched_earth/subscribers/"

SimpleCov.add_filter 'vendor'
SimpleCov.add_filter 'test'
SimpleCov.add_filter 'lib/scorched_earth/renders/'
SimpleCov.add_filter 'lib/scorched_earth/game_window.rb'

SimpleCov.start
