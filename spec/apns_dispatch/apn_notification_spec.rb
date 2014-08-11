require 'spec_helper'

describe ApnsDispatch::ApnNotification do
  it 'sends a notification packet to the connection' do
    token = '7307dea69c58e9625250aabb040594e1a031f574dba5d97549fbe211327aff4c'
    message = 'test message'
    options = { aps: { badge: 1 }, order_id: 1 }
    @connection = stub
    @apn_notificiation = ApnsDispatch::ApnNotification.new(@connection, token, message, options)

    expected_message = { aps: { alert: message, sound: 'default', badge: 1}, order_id: 1}
    payload = expected_message.to_json
    @packet = [0, 32, [token].pack('H*'), payload.bytesize, payload].pack('cna*na*')

    @connection.should_receive(:write).with(@packet)

    @apn_notificiation.send_notification
  end

  it 'strips nil values' do
    token = '7307dea69c58e9625250aabb040594e1a031f574dba5d97549fbe211327aff4c'
    message = 'test message'
    options = { aps: { badge: 1, :sound => nil }, order_id: 1 }
    @connection = stub
    @apn_notificiation = ApnsDispatch::ApnNotification.new(@connection, token, message, options)

    expected_message = { aps: { alert: message, badge: 1}, order_id: 1}
    payload = expected_message.to_json
    @packet = [0, 32, [token].pack('H*'), payload.bytesize, payload].pack('cna*na*')

    @connection.should_receive(:write).with(@packet)

    @apn_notificiation.send_notification
  end
end
