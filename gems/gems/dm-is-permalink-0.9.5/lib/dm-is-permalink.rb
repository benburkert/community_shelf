require 'rubygems'
require 'pathname'

gem 'dm-core', '>=0.9.5'
require 'dm-core'

gem 'dm-validations', '>=0.9.5'
require 'dm-validations'

require Pathname(__FILE__).dirname.expand_path / 'dm-is-permalink' / 'is' / 'permalink.rb'


module DataMapper
  module Resource
    module ClassMethods
      include DataMapper::Is::Permalink
    end
  end
end