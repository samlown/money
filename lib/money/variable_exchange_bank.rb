require 'thread'
require 'money/errors'
require 'net/http'
require 'rexml/document'

# Class for aiding in exchanging money between different currencies.
# By default, the Money class uses an object of this class (accessible through
# Money#bank) for performing currency exchanges.
#
# By default, VariableExchangeBank has no knowledge about conversion rates.
# One must manually specify them with +add_rate+, after which one can perform
# exchanges with +exchange+. For example:
#
#  bank = Money::VariableExchangeBank.new
#  bank.add_rate("USD", "CAD", 1.24515)
#  bank.add_rate("CAD", "USD", 0.803115)
#  
#  # Exchange 100 CAD to USD:
#  bank.exchange(100_00, "CAD", "USD")  # => 124
#  # Exchange 100 USD to CAD:
#  bank.exchange(100_00, "USD", "CAD")  # => 80
class Money
  class VariableExchangeBank
    # Returns the singleton instance of VariableExchangeBank.
    #
    # By default, <tt>Money.default_bank</tt> returns the same object.
    def self.instance
      @@singleton
    end
    
    def initialize(file = nil)
      @rates = {}
      @xml = 
      if file and file.readable?
        File.open(file) do |f|
          @xml = REXML::Document.new(f.read)
        end
      else
        @xml = REXML::Document.new(
          Net::HTTP.get(
            URI.parse('http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml')
                     )
        )
      end
      create_rates
    end

    def add_rate(currency, rate)
      @rates[currency.upcase] = (currency.upcase != "USD") ? (rate * @rates["USD"]) : rate
    end

    def get_rate(currency = nil)
      return nil unless @rates[currency]
      (currency != "USD") ? @rates[currency.upcase] / @rates["USD"] : @rates[currency.upcase]
    end
    
    # Given two currency names, checks whether they're both the same currency.
    #
    #   bank = VariableExchangeBank.new
    #   bank.same_currency?("usd", "USD")   # => true
    #   bank.same_currency?("usd", "EUR")   # => false
    def same_currency?(currency1, currency2)
      currency1.upcase == currency2.upcase
    end
    
    # Exchange the given amount of cents in +from_currency+ to +to_currency+.
    # Returns the amount of cents in +to_currency+ as an integer, rounded down.
    #
    # If the conversion rate is unknown, then Money::UnknownRate will be raised.
    def exchange(cents, from_currency, to_currency)
      from_currency.upcase!
      to_currency.upcase!
      if !@rates[from_currency] or !@rates[to_currency]
        raise Money::UnknownRate, "No conversion rate known for '#{from_currency}' -> '#{to_currency}'"
      end
      ((cents / @rates[from_currency]) * @rates[to_currency]).round
    end


    def create_rates
      @rates["EUR"] = 1.0
      @xml.elements.each('//Cube') do |ele|
        @rates[ele.attributes['currency'].upcase] = ele.attributes['rate'].to_f if ele.attributes['currency']
      end
    end
    
    @@singleton = VariableExchangeBank.new
  end
end
