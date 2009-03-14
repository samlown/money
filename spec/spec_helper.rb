begin
  require 'spec'
  require 'active_record'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end
require 'active_record'
$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'money'

config = YAML.load_file(File.dirname(__FILE__) + '/db/database.yml')
ActiveRecord::Base.logger = Logger.new("/tmp/money-debug.log")
ActiveRecord::Base.establish_connection(config)


def load_schema
  load(File.dirname(__FILE__) + "/db/schema.rb")
end
