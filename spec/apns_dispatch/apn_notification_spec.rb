require 'spec_helper'

describe ApnsDispatch::ApnNotification do
  before do
    token = '7307dea69c58e9625250aabb040594e1a031f574dba5d97549fbe211327aff4c'
    message = 'test message'
    options = { order_id: 12345 }
    @connection = stub
    @apn_notificiation = ApnsDispatch::ApnNotification.new(@connection, token, message, options)

    payload = { aps: { alert: message, sound: 'default'} }.merge(options).to_json
    @packet = [0, 32, [token].pack('H*'), payload.bytesize, payload].pack('cna*na*')
  end

  it 'sends a notification packet to the connection' do
    @connection.should_receive(:write).with(@packet)

    @apn_notificiation.send_notification
  end
end
