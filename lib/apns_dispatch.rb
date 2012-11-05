# This gem provides a simple Ruby wrapper for communicating with the Apple Push Notification service
# (APNs). It handles SSL, sending push notifications to APNs using Apple's binary protocol, and
# retriving failed device tokens using the APN feedback service. Both development and production
# certificates are handled.
#
# Author::    Costa Walcott  (mailto:costa@scvngr.com)
# Copyright:: Copyright (c) 2012 SCVNGR, Inc.
# License::   MIT

require 'json'

require 'apns_dispatch/apn_feedback'
require 'apns_dispatch/apn_notification'
require 'apns_dispatch/apns_connection'
require 'apns_dispatch/apns_connection_pool'
require 'apns_dispatch/version'
