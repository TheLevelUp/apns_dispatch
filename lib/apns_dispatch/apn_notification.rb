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

    def message_information
      {
        aps: {
          alert: @message,
          sound: 'default'
        }
      }
    end

    def notification_packet
      [command, binary_token.bytesize, binary_token, payload.bytesize, payload].pack 'cna*na*'
    end

    def payload
      message_information.merge(@options).to_json
    end
  end
end
