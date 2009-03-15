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
    # :with_currency => true
    #
    def has_money(*attributes)
      config = {:with_currency => true, :converter => lambda { |m| m ||=0; (m) ? m.to_money : "0".to_money },
                :allow_nil => false }.update(attributes.extract_options!)

      attributes.each do |attr|
        mapping = [[config[:cents] || "#{attr}_cents", 'cents']]
        mapping << [config[:currency] || "#{attr}_currency", 'currency'] if config[:with_currency]

        composed_of attr, :class_name => 'Money', :allow_nil => config[:allow_nil],
           :mapping => mapping, :converter => config[:converter]
      end

    end

  end

end
