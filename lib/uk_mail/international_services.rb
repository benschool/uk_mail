require 'byebug'

module UKMail
  module InternationalServices
    def self.list(params)
      url = if UKMail.config.env == :production
        'https://services.dhlparcel.co.uk/v2/products/parcels/deliveryProducts'
      else
        'https://services.qa.dhlparcel.co.uk/v2/products/parcels/deliveryProducts'
      end

      # TODO: Look up the limits for dimensions fields and perform validations.
      # If we exceed the limits, UK Mail returns an empty array with no message.

      query = {
        countryCode: params[:country_code],
        weight: params[:weight],
        length: params[:length],
        width: params[:width],
        height: params[:height],
        recipientAddressType: params[:recipient_address_type],
        recipientPostcode: params[:recipient_postcode],
        doorstepOnly: params[:doorstep_only]
      }

      client = HTTPClient.new
      client.default_header['X-Api-Key'] = UKMail.config.api_key
      response = client.get(url, query)

      if response.status == 200
        return JSON.parse(response.body).map do |response_service|
          InternationalService.new(
            response_service['ProductDescription'],
            response_service['ProductCode']
          )
        end
      end

      if response.status == 401
        raise UKMail::ServiceError, 'API key is invalid.'
      end

      if response.status == 400
        error_message = JSON.parse(response.body)['Errors'].values.join("\n")
        raise UKMail::ServiceError, error_message
      end

      raise UKMail::ServiceError, 'An unknown error occurred.'
    end

    class InternationalService
      attr_accessor :name
      attr_accessor :key

      def initialize(name, key)
        @name = name
        @key = key
      end
    end
  end
end
