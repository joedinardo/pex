require 'models/sfdc.sobject'
require 'httparty'
require 'uri'

module SFDC
  module KMTracking
    class Event
      include HTTParty
      base_uri ENV["KM_TRACKING_ENDPOINT"]  # https://trk.kissmetrics.com

      def initialize(sobject, event_name = "")
        @apikey     = ENV["KM_API_KEY"]  # Your KISSmetrics API key
        @sobject    = sobject
        @event_name = event_name
      end

      # POSTs the KISSmetrics account-based endpoint with data representing this existing event.
      # @note Makes a network request!
      #
      # @return nil
      def record
        if can_record_event?
          params = URI.encode_www_form( {
            :_n => km_event_name,
            :_p => km_identity,
            :_k => @apikey
          }.merge(km_properties) )

          puts "Posting to #{self.class.base_uri}/e with parameters: #{params}"
          self.class.get("/e", :query => params)
        end
      end

      # Returns whether there is enough info in this Event instance to record a KISSmetrics event.
      #
      # @return [Boolean]
      def can_record_event?
        !!(km_identity && km_event_name)
      end

      # Generates the name of the KISSmetrics event.
      #
      # @return [String]
      def km_event_name
        @event_name
      end

      # Generates the KISSmetrics identity.
      #
      # @return [String]
      def km_identity
        @sobject.email || @sobject.email__c
      end

      # Generates a hash of the KISSmetrics properties.
      #
      # @return [Hash]
      def km_properties
        km_props = {}
        km_props["Salesforce URL"] = @sobject.url

        if @sobject.opportunity?
          if km_event_name == "Salesforce Opportunity Closed (Won)"
            km_props["Opportunity Amount Won"] = @sobject.amount
          elsif km_event_name == "Salesforce Opportunity Closed (Lost)"
            km_props["Opportunity Amount Lost"] = @sobject.amount
          end
          km_props["Opportunity Amount"] = @sobject.amount
        end

        km_props
      end
    end

    class Events < Array
      # Creates an array of Event objects
      def initialize(sobjects = [], event_name)
        sobjects.each {|sobject_hash|
          self << SFDC::KMTracking::Event.new(
            SFDC::KMTracking::SObject.new(sobject_hash),
            event_name
          )
        }
      end

      # Calls `record` on each Event object in self.
      def record_all
        self.each {|event|
          event.record
        }
      end
    end
  end
end
