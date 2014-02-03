require 'spec_helper'

describe ApnsDispatch::ApnsConnection do
  # Helpers
  def self.should_run_command_with_connection(command, argument)
    before do
      TCPSocket.stub new: stub(close: true)

      certificate = 'test-certificate'
      @ssl = stub(close: true, connect: true, read: true, 'sync=' => true, write: true)
      OpenSSL::SSL::SSLSocket.stub new: @ssl
      OpenSSL::X509::Certificate.stub new: certificate
      OpenSSL::PKey::RSA.stub new: certificate

      @apns_connection = ApnsDispatch::ApnsConnection.new(certificate)
    end

    it 'runs the given block' do
      @ssl.should_receive(command).with(argument)

      @apns_connection.send command, argument
    end

    it 'uses the correct host and port' do
      TCPSocket.should_receive(:new).with(@apns_connection.host, @apns_connection.port)

      @apns_connection.send command, argument
    end

    context 'when the connection throws an error' do
      before do
        @ssl.stub(command).with(argument).and_return do
          unless @run
            @run = true
            raise OpenSSL::SSL::SSLError
          end
        end
      end

      it 'retries once' do
        @ssl.should_receive(command).with(argument).twice

        @apns_connection.send command, argument
      end

      it 'reconnects before retrying' do
        OpenSSL::SSL::SSLSocket.should_receive(:new).twice

        @apns_connection.send command, argument
      end
    end

    context 'when there is no connection' do
      it 'initiates a connection' do
        @ssl.should_receive :connect

        @apns_connection.send command, argument
      end
    end

    context 'when there is already a connection' do
      before do
        @apns_connection.instance_variable_set :@ssl, @ssl
      end

      it 'does not reconnect' do
        @ssl.should_receive(:connect).never

        @apns_connection.send command, argument
      end
    end
  end

  it 'has the correct APNs hosts and ports' do
    ApnsDispatch::ApnsConnection::FEEDBACK_PORT.should == 2196
    ApnsDispatch::ApnsConnection::GATEWAY_PORT.should == 2195
    ApnsDispatch::ApnsConnection::PRODUCTION_FEEDBACK_HOST.should == 'feedback.push.apple.com'
    ApnsDispatch::ApnsConnection::PRODUCTION_GATEWAY_HOST.should == 'gateway.push.apple.com'
    ApnsDispatch::ApnsConnection::SANDBOX_FEEDBACK_HOST.should == 'feedback.sandbox.push.apple.com'
    ApnsDispatch::ApnsConnection::SANDBOX_GATEWAY_HOST.should == 'gateway.sandbox.push.apple.com'
  end

  context 'with :feedback option and :production option' do
    before do
      @connection = ApnsDispatch::ApnsConnection.new('test', feedback: true, production: true)
    end

    it 'uses the production feedback host and feedback port' do
      @connection.host.should == ApnsDispatch::ApnsConnection::PRODUCTION_FEEDBACK_HOST
      @connection.port.should == ApnsDispatch::ApnsConnection::FEEDBACK_PORT
    end
  end

  context 'with :feedback option only' do
    before do
      @connection = ApnsDispatch::ApnsConnection.new('test', feedback: true)
    end

    it 'uses the sandbox feedback host and feedback port' do
      @connection.host.should == ApnsDispatch::ApnsConnection::SANDBOX_FEEDBACK_HOST
      @connection.port.should == ApnsDispatch::ApnsConnection::FEEDBACK_PORT
    end
  end

  context 'with :production option only' do
    before do
      @connection = ApnsDispatch::ApnsConnection.new('test', production: true)
    end

    it 'uses the production gateway host and gateway port' do
      @connection.host.should == ApnsDispatch::ApnsConnection::PRODUCTION_GATEWAY_HOST
      @connection.port.should == ApnsDispatch::ApnsConnection::GATEWAY_PORT
    end
  end

  context 'with no options' do
    before do
      @connection = ApnsDispatch::ApnsConnection.new('test')
    end

    it 'uses the sandbox gateway host and gateway port' do
      @connection.host.should == ApnsDispatch::ApnsConnection::SANDBOX_GATEWAY_HOST
      @connection.port.should == ApnsDispatch::ApnsConnection::GATEWAY_PORT
    end
  end

  context 'with read command' do
    should_run_command_with_connection :read, 10
  end

  context 'with write command' do
    should_run_command_with_connection :write, 'test message'
  end
end
