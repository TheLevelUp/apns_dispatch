require 'spec_helper'

describe ApnsDispatch::ApnFeedback do
  # Helpers
  def packed_feedback(feedback)
    [feedback[1].to_i, 140, feedback[0]].pack 'N1n1H*'
  end

  before do
    @failed_token = ['ced238e503ece0f6d664e1b8bdae7d9dffc39c2303bf7466cd83cb2783ad40b2',
      Time.new(2012, 9, 1)]

    apn_connection = stub
    apn_connection.stub(:read).with(38).and_return packed_feedback(@failed_token), nil

    @apn_feedback = ApnsDispatch::ApnFeedback.new(apn_connection)
  end

  it 'returns the failed tokens' do
    [@failed_token].should == @apn_feedback.failed_device_tokens
  end
end
