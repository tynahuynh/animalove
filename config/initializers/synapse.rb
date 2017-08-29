require 'synapse_pay_rest'
    args = {
      # synapse client_id
      client_id:        ENV.fetch('CLIENT_ID'),
      # synapse client_secret
      client_secret:    ENV.fetch('CLIENT_SECRET'),
      # a hashed value, either unique to user or static for app
      fingerprint:      ENV.fetch('FINGERPRINT'),
      # the user's IP
      ip_address:       ENV.fetch('IP_ADDRESS'),
      # (optional) requests go to sandbox endpoints if true
      development_mode: true,
      # (optional) if true logs requests to stdout
      logging:          true,
      # (optional) file path to write logs to
      log_to:           nil
    }

$client = SynapsePayRest::Client.new(args)
