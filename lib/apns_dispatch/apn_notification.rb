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
    end

    private

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
