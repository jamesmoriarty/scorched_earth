require "rubygems"
require "bundler/setup"

require "debugger"
require "benchmark"
require "logger"
require 'gosu'
require "chingu"
require 'texplay'
require "ashton"
require "require_all"

require_all Dir.glob("**/*.rb").reject{ |f| f.match("spec") || f.match("lib/app.rb")}

root_path = File.dirname(File.expand_path("..", __FILE__))

Gosu::Image.autoload_dirs << File.join(root_path, "media", "images")
Gosu::Sound.autoload_dirs << File.join(root_path, "media", "sounds")
Gosu::Font.autoload_dirs  << File.join(root_path, "media", "fonts")

