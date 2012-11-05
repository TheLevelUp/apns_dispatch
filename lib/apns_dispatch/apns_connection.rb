require 'openssl'
require 'socket'

module ApnsDispatch
  # Handles communication with the Apple Push Notification service (APNs).
  # Based on code from https://github.com/itspriddle/apnd.

  class ApnsConnection
    # Constants
    FEEDBACK_PORT = 2196
    GATEWAY_PORT = 2195
    PRODUCTION_FEEDBACK_HOST = 'feedback.push.apple.com'
    PRODUCTION_GATEWAY_HOST = 'gateway.push.apple.com'
    SANDBOX_FEEDBACK_HOST = 'feedback.sandbox.push.apple.com'
    SANDBOX_GATEWAY_HOST = 'gateway.sandbox.push.apple.com'

    # Attributes
    attr_reader :certificate, :host, :options, :port

    def initialize(certificate, options={})
      if options[:feedback]
        @port = FEEDBACK_PORT

        if options[:production]
          @host = PRODUCTION_FEEDBACK_HOST
        else
          @host = SANDBOX_FEEDBACK_HOST
        end
      else
        @port = GATEWAY_PORT

        if options[:production]
          @host = PRODUCTION_GATEWAY_HOST
        else
          @host = SANDBOX_GATEWAY_HOST
        end
      end

      @certificate = certificate
      @options = options
    end

    def read(length)
      with_connection { @ssl.read(length) }
    end

    def write(message)
      with_connection { @ssl.write(message) }
    end

    private

    def connect!
      context = OpenSSL::SSL::SSLContext.new
      context.cert = OpenSSL::X509::Certificate.new(@certificate)
      context.key = OpenSSL::PKey::RSA.new(@certificate)

      @sock = TCPSocket.new(host, port)
      @ssl = OpenSSL::SSL::SSLSocket.new(@sock, context)
      @ssl.sync = true
      @ssl.connect
    end

    def connected?
      !@ssl.nil?
    end

    def disconnect!
      @ssl.close
      @sock.close
      @ssl = nil
      @sock = nil
    end

    def reconnect!
      disconnect!
      connect!
    end

    def with_connection
      unless connected?
        connect!
      end

      attempted = false

      begin
        if block_given?
          yield
        end
      rescue Errno::EPIPE, OpenSSL::SSL::SSLError
        unless attempted
          reconnect!
          attempted = true
          retry
        end
      end
    end
  end
end
