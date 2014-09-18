require 'models/sfdc.event'

module SFDC
  module KMTracking
    class Client
      def initialize
        # This is the same string as the webhookSecret defined in KMTracking.cls
        @secret = ENV['SFDC_TRACKING_SECRET']
      end

      # Records a KM event for each Salesforce SObject contained in the body.
      #
      # @param body [string] a POST string representing an array of Salesforce SObjects
      # @param event_name [string] a string describing the KM event to record
      # @return nil
      def parse_and_record_events(body, event_name)
        events = SFDC::KMTracking::Events.new( JSON.parse(body), event_name )
        events.record_all()
      end

      # Checks for basic HTTP authentication with the Authorization header
      #
      # @param header_signature [String] the Authorization header from Salesforce's postback
      # @return [Boolean] whether the signature matches the generated one
      def valid_signature?(header_signature)
        return !header_signature.nil? && header_signature.strip == signature.strip
      end

      private
      def signature
        "Basic #{@secret.strip}"
      end
    end
  end
end
