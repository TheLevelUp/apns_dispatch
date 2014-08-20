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
      # strip out nil values in :aps and root space to save bytes
      Hash[message_information.reject { |k,v| v.nil? }.map do |k,v|
        [k, v.kind_of?(Hash) ? v.reject { |k,v| v.nil? } : v]
      end].to_json
    end
  end
end
