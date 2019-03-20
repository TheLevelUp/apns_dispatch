**This project is unmaintained.** We recommend using a library compatible with Apple's newer [HTTP/2-based API](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingwithAPNs.html#//apple_ref/doc/uid/TP40008194-CH11-SW1), such as [apnotic](https://github.com/ostinelli/apnotic).

# ApnsDispatch

A simple Ruby framework for sending push notifications and receiving feedback using the Apple Push Notification service

## Installation

Add this line to your application's Gemfile:

    gem 'apns_dispatch'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apns_dispatch

## Sending Notifications

    connection = ApnsConnection.new(CERTIFICATE, production: true)
    ApnNotification.new(connection, DEVICE_TOKEN, 'a message to a device').send_notification

## Checking the Feedback Service

[Apple recommends](https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingWIthAPS/CommunicatingWIthAPS.html#//apple_ref/doc/uid/TP40008194-CH101-SW3)
periodically checking their feedback service for device tokens that have failed delivery. The feedback
service also returns the time of the failure. If a device token was registered before the failure time,
it should be removed from your system.

    connection = ApnsConnection.new(CERTIFICATE, production: true, feedback: true)
    ApnFeedback.new(connection).failed_device_tokens.each do |device_token, failure_time|
        # Delete this device token from your system, if the registration time is before failure_time
    end

## Connection Pooling

If notifications are sent frequently, latency will be improved by reusing connections to the Push
Notification service. ApnsDispatch also provides connection pooling:

    # Initiates a new connection to the APNs
    connection = ApnsConnectionPool.connection(CERTIFICATE, production: true)

    # This will return the same connection, rather than initiating a new one
    connection = ApnsConnectionPool.connection(CERTIFICATE, production: true)

## Requirements

`apns_dispatch` requires Ruby 1.9+.

## License

`apns_dispatch` is written by Costa Walcott, and is Copyright 2012 SCVNGR, Inc. It is free software,
and may be redistributed under the terms specified in the MIT-LICENSE file.
