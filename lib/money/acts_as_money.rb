# Money require 'money'
# based on github.com/collectiveidea/acts_as_money
module ActsAsMoney #:nodoc:
  def self.included(base) #:nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    #
    # class Product
    #   has_money :value, :tax, :opts => opts
    # end
    #
    # @product.value.class      #=>  "Money"
    # @product.value_cents      #=>  "1000"
    # @product.tax_currency     #=>  "USD"
    #
    # Opts:
    # :cents => "pennys"        #=>  @product.pennys
    # :currency => "currency"   #=>  @product.currency
    # :allow_nil => true
    # :with_currency => false
    # :with_cents => true       #=>  1000.to_money #=> #<Money @cents=1000>
    #
    def has_money(*attributes)
      config = {:with_currency => true, :with_cents => false,
                :allow_nil => false }.update(attributes.extract_options!)

      for attribute in attributes do
        mapping = [[config[:cents] || "#{attribute}_cents", 'cents']]
        mapping << [config[:currency] || "#{attribute}_currency", 'currency'] if config[:with_currency]

        composed_of attribute, :class_name => 'Money', :allow_nil => config[:allow_nil],
           :mapping => mapping, :converter => lambda { |m| (m||0).to_money(config[:with_cents]) }
      end

    end

  end

end
