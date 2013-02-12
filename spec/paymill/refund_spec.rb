require "spec_helper"

describe Paymill::Refund do
  let(:valid_attributes) do
    
    {
      transaction:                 {
        id:     "tran_123",
        amount:   80,
        currency: "EUR",
      },
      amount: 420,
      description: "Returned",
      livemode: false
    }
  end

  let (:refund) do
    Paymill::Refund.new(valid_attributes)
  end

  describe "#initialize" do
    it "initializes all attributes correctly" do
      refund.transaction[:id].should eql("tran_123")
      refund.transaction[:amount].should eql(80)
      refund.transaction[:currency].should eql("EUR") 
      refund.amount.should eql(420)
      refund.status.should eql("open")
      refund.description.should eql("Returned")
      refund.livemode.should be_false
    end
  end

  describe ".find" do
    it "makes a new GET request using the correct API endpoint to receive a specific subscription" do
      Paymill.should_receive(:request).with(:get, "refunds/123", {}).and_return("data" => {}) 
    end
  end

  describe ".all" do
    it "makes a new GET request using the correct API endpoint to receive all subscriptions" do
      Paymill.should_receive(:request).with(:get, "refunds/", {}).and_return("data" => {})
      Paymill::Refund.all
    end
  end


  describe ".create" do
    it "makes a new POST request using the correct API endpoint" do
      Paymill.should_receive(:request).with(:post, "refunds", valid_attributes).and_return("data" => {})
      Paymill::Refund.create(valid_attributes)
    end
  end
end