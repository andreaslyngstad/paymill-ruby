require "spec_helper"

describe Paymill::Subscription do
  let(:valid_attributes) do
    {
      plan:                 {
        name:     "Nerd special",
        amount:   123,
        interval: "week"
      },
      livemode:             false,
      trial_start:          1349945681,
      trial_end:            1349945682,
      cancel_at_period_end: false,
      next_capture_at: 1349945682,
      client:               {
        email: "stefan.sprenger@dkd.de"
      }
    }
  end

  let (:subscription) do
    Paymill::Subscription.new(valid_attributes)
  end

  describe "#initialize" do
    it "initializes all attributes correctly" do
      subscription.plan[:name].should eql("Nerd special")
      subscription.plan[:amount].should eql(123)
      subscription.plan[:interval].should eql("week")
      subscription.livemode.should be_false
      subscription.cancel_at_period_end.should be_false
      subscription.client[:email].should eql("stefan.sprenger@dkd.de")
      subscription.trial_start.should eql(1349945681)
      subscription.trial_end.should eql(1349945682)
    end
  end

  describe ".find" do
    it "makes a new GET request using the correct API endpoint to receive a specific subscription" do
      Paymill.should_receive(:request).with(:get, "subscriptions/123", {}).and_return("data" => {})
      Paymill::Subscription.find("123")
    end
  end

  describe ".all" do
    it "makes a new GET request using the correct API endpoint to receive all subscriptions" do
      Paymill.should_receive(:request).with(:get, "subscriptions/", {}).and_return("data" => {})
      Paymill::Subscription.all
    end
  end

  describe ".delete" do
    it "makes a new DELETE request using the correct API endpoint" do
      Paymill.should_receive(:request).with(:delete, "subscriptions/123", {}).and_return(true)
      Paymill::Subscription.delete("123")
    end
  end

  describe ".create" do
    it "makes a new POST request using the correct API endpoint" do
      Paymill.should_receive(:request).with(:post, "subscriptions", valid_attributes).and_return("data" => {})
      Paymill::Subscription.create(valid_attributes)
    end
  end

  describe "#update_attributes" do
    it "makes a new PUT request using the correct API endpoint" do
      changed_attributes = {:cancel_at_period_end => true}
      subscription.id    = 'sub_123'

      Paymill.should_receive(:request).with(:put, "subscriptions/sub_123", changed_attributes).and_return("data" => changed_attributes)

      subscription.update_attributes(changed_attributes)
    end

    it "should set the returned attributes on the instance" do
      Paymill.should_receive(:request).and_return("data" => {:cancel_at_period_end => true})
      subscription.update_attributes({})
      subscription.cancel_at_period_end.should be_true
    end
  end
end
