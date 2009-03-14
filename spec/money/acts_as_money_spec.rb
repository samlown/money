require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../../rails/init.rb'

# Uncomment this once to create the db
load_schema

class Account < ActiveRecord::Base
  has_money :value, :total, :allow_nil => true
end

class Product < ActiveRecord::Base
  has_money :value, :allow_nil => false
  has_money :tax, :cents => "pennys", :with_currency => false

  validates_presence_of :value
end

describe "Acts as Money" do

    it "should require money" do
      @account = Account.create(:value => nil)
      p @account.errors
      @account.should have(1).errors
    end

    it "should require money" do
      @product = Product.create(:value => nil)
      @product.should have(1).errors
    end

    it "should require money" do
      @product_fake = Product.create(:value => nil)
      @product_fake.value_cents.should eql(0)
    end

    it "should create" do
     @account = Account.create!(:value => 10, :total => "20 BRL")
     @account.should be_valid
    end


  describe "Account" do

    before(:each) do
      @account = Account.create!(:value => 10, :total => "20 BRL")
    end

    it "should return an instance of Money" do
      @account.value.should be_instance_of(Money)
    end

    it "should write to the db" do
      p @account
      @account.value.to_s.should eql("10.00")
    end

    it "should include nicely" do
      @account.value.to_s.should eql("10.00")
      @account.total.to_s.should eql("20.00")
    end

    it "should map cents" do
      @account.value_cents.to_s.should eql("1000")
    end

    it "should map currency" do
      @account.value_currency.should eql("USD")
      @account.total_currency.should eql("BRL")
    end

  end

  describe "Product" do

    before(:each) do
      @product = Product.create(:value => 10, :tax => 2)
    end

    it "should map attributes" do
      @product.pennys.should eql(200)
    end

    it "should map currency on tax" do
      @product.should_not respond_to(:tax_currency)
    end

  end

end
