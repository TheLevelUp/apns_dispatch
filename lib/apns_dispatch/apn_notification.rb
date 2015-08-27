module ApnsDispatch
  # Creates a packaged notification for the APNs. Based on code from https://github.com/jpoz/APNS.

  class ApnNotification
    # Constants
    COMMAND = 0

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
      [@token].pack 'H*'.freeze
    end

    def default_aps_message
      { alert: @message, sound: 'default'.freeze }
    end

    def message_information
      @options.dup.tap do |message|
        message[:aps] = default_aps_message.merge(message[:aps] || {})
      end
    end

    def notification_packet
      [COMMAND, binary_token.bytesize, binary_token, payload.bytesize, payload].
        pack 'cna*na*'.freeze
    end

    def payload
      message_information.to_json
    end
  end
end
