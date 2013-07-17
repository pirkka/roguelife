begin
  # in case you use Gosu via RubyGems.
  require 'rubygems'
rescue LoadError
  # in case you don't.
end

require 'paint'

path = File.dirname(__FILE__)

Dir[path + '/*/*.rb'].each {|file| require file }
