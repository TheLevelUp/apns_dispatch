require 'digest/md5'
require 'apns_dispatch/null_apns_connection'

module ApnsDispatch
  # Caches and returns individual unique ApnsConnections in memory.

  class ApnsConnectionPool
    def self.connection(certificate, options={})
      if certificate
        cache_key = cache_key(certificate, options)

        @connections ||= {}
        @connections[cache_key] ||= ApnsDispatch::ApnsConnection.new(certificate, options)
      else
        ApnsDispatch::NullApnsConnection.new
      end
    end

    private

    def self.cache_key(certificate, options)
      [Digest::MD5.hexdigest(certificate), options.hash]
    end
  end
end
