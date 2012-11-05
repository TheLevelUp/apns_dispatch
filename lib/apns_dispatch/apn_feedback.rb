module ApnsDispatch
  # Retrieves and returns failed device tokens from production and development APNs connections.

  class ApnFeedback
    # Constants
    FEEDBACK_PACKET_FORMAT = 'N1n1H140'
    FEEDBACK_PACKET_LENGTH = 38

    def initialize(connection)
      @connection = connection
    end

    def failed_device_tokens
      apns_feedback = []

      while line = @connection.read(FEEDBACK_PACKET_LENGTH)
        apns_feedback << unpackage(line)
      end

      apns_feedback
    end

    private

    def unpackage(line)
      feedback = line.unpack(FEEDBACK_PACKET_FORMAT)
      [feedback[2], Time.at(feedback[0])]
    end
  end
end
