module ApnsDispatch
  # Creates a packaged notification for the APNs. Based on code from https://github.com/jpoz/APNS.

  class ApnNotification
    def initialize(connection, token, message, options = {})
      @connection = connection
      @token = token
      @message = message
      @options = options
    end

    def send_notification
      @connection.write notification_packet
      status, identifier = read_status(@connection)
      if status && status == 0
        return true
      else
        # Assume all errors have the possibility of poisoning a connection
        @connection.disconnect!
        return false
      end
    end

    private

    STATUS_PACKET_SIZE = 6
    # Constant value returned by APNS. See: https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/CommunicatingWIthAPS.html
    STATUS_PACKET_COMMAND = 8
    # Command, Status code, Notification Identifier
    STATUS_PACKET_FORMAT = 'CCN'

    def read_status(connection)
      packet = connection.read(STATUS_PACKET_SIZE)
      if !packet
        # Timeout or some other socket error.
        return nil, nil
      end

      command, status, identifier = packet.unpack(STATUS_PACKET_FORMAT)
      if command.to_i != STATUS_PACKET_COMMAND
        # APNS format has changed in some way. Fail fast.
        raise(ArgumentError, "APNS Return Command Constant Incorrect: #{command}")
      end
      return status.to_i, identifier
    end

    def binary_token
      [@token].pack 'H*'
    end

    def command
      0
    end

    def default_aps_message
      { alert: @message, sound: 'default' }
    end

    def message_information
      @options.dup.tap do |message|
        message[:aps] = default_aps_message.merge(message[:aps] || {})
      end
    end

    def notification_packet
      [command, binary_token.bytesize, binary_token, payload.bytesize, payload].pack 'cna*na*'
    end

    def payload
      message_information.to_json
    end
  end
end
