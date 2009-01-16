# Money require 'money'
# based on github.com/collectiveidea/acts_as_money
module ActsAsMoney #:nodoc:
  def self.included(base) #:nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    # class Product
    #   has_money :value, :tax
    # end
    #
    # @product.value.class      #=>  "Money"
    # @product.value_in_cents   #=>  "1000"
    # @product.tax_currency     #=>  "USD"
    #
    # Opts:
    # :cents => "pennys"        #=>  tax_pennys
    # :currency => "currency"   #=>  tax_currency
    # :allow_nil => true
    # :with_currency => true
    #
    def has_money(*attributes)
      config = {
        :allow_nil => true, :currency => "currency", :cents => "in_cents",
        :with_currency => true, :converter => lambda { |m| m.to_money }
      }.merge(attributes.extract_options!)

      attributes.each do |attr|
        mapping = [["#{attr}_#{config[:cents]}", 'cents']]
        mapping << ["#{attr}_#{config[:currency]}", 'currency'] if config[:with_currency]

        composed_of attr, :class_name => 'Money',:allow_nil => config[:allow_nil],
           :mapping => mapping, :converter => config[:converter]
      end

    end

  end

end
