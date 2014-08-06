require 'spec_helper'

describe ApnsDispatch::ApnNotification do
  before do
    token = '7307dea69c58e9625250aabb040594e1a031f574dba5d97549fbe211327aff4c'
    message = 'test message'
    options = { aps: { badge: 1 }, order_id: 1 }
    @connection = stub
    @apn_notificiation = ApnsDispatch::ApnNotification.new(@connection, token, message, options)

    expected_message = { aps: { alert: message, sound: 'default', badge: 1}, order_id: 1}
    payload = expected_message.to_json
    @packet = [0, 32, [token].pack('H*'), payload.bytesize, payload].pack('cna*na*')
    @success_status_packet = [8, 0, 0].pack('CCN')
    @error_status_packet = [8, 255, 0].pack('CCN') # Unknown APNS error code: 255
  end

  it 'sends a notification packet to the connection and reads the status' do
    @connection.should_receive(:write).with(@packet)
    @connection.should_receive(:read).with(@success_status_packet.size) { @success_status_packet }

    result = @apn_notificiation.send_notification
    result.should eq(true)
  end

  it 'sends a notification packet to the connection and disconnects on error' do
    @connection.should_receive(:write).with(@packet)
    @connection.should_receive(:read).with(@error_status_packet.size) { @error_status_packet }
    @connection.should_receive(:disconnect!)

    result = @apn_notificiation.send_notification
    result.should eq(false)
  end
end
