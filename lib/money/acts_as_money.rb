# Money require 'money'
# based on github.com/collectiveidea/acts_as_money
module ActsAsMoney #:nodoc:
  def self.included(base) #:nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    #
    # has_money :attr1, :attr2
    #
    # Opts:
    # :cents => "cents"
    # :currency => "BRL"
    # :allow_nil => false
    # :with_currency => true
    #
    def has_money(*attributes)
      config = {
        :allow_nil => true, :currency => "currency", :cents => "cents",
        :with_currency => true, :converter => lambda { |m| m.to_money }
      }.merge(attributes.extract_options!)

      attributes.each do |attr|
        mapping = [["#{attr}_#{config[:cents]}", 'cents']]
        mapping << ["#{attr}_#{config[:currency]}", 'currency'] if config[:with_currency]

        composed_of attr, :class_name => 'Money',:allow_nil => config[:allow_nil],
           :mapping => mapping, :converter => lambda {|m| m.to_money }
      end

    end

  end

end
