require 'money/acts_as_money'

ActiveRecord::Base.send :include, ActsAsMoney
