module SFDC
  module KMTracking
    class SObject
      def initialize(sobject_hash = {})
        @sobject_hash = sobject_hash
      end

      def attributes
        @sobject_hash.fetch("attributes", {})
      end

      def type
        attributes.fetch("type", nil)
      end

      def url
        attributes.fetch("url", nil)
      end

      def lead?
        type == "Lead"
      end

      def opportunity?
        type == "Opportunity"
      end

      def id
        @sobject_hash.fetch("Id", nil)
      end

      def email
        @sobject_hash.fetch("Email", nil)
      end

      def email__c
        @sobject_hash.fetch("Email__c", nil)
      end

      def created_date
        @sobject_hash.fetch("CreatedDate", nil)
      end

      def converted_date
        @sobject_hash.fetch("ConvertedDate", nil)
      end

      def amount
        @sobject_hash.fetch("Amount", nil)
      end
    end
  end
end
