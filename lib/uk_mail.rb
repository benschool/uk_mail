require 'uk_mail/version'
require 'uk_mail/exceptions'
require 'uk_mail/session'
require 'uk_mail/domestic_services'
require 'uk_mail/international_services'
require 'uk_mail/postcode_data'
require 'uk_mail/ireland_data'

require 'uk_mail/soap_service/authentication'
require 'uk_mail/soap_service/collection'
require 'uk_mail/soap_service/consignment'

require 'uk_mail/service/service_base'
require 'uk_mail/service/request_base'

require 'uk_mail/service/authentication'
require 'uk_mail/service/collection'
require 'uk_mail/service/collection/book_collection_request'
require 'uk_mail/service/consignment'
require 'uk_mail/service/consignment/add_domestic_consignment_request'
require 'uk_mail/service/consignment/add_international_consignment_request'
require 'uk_mail/service/consignment/add_packets_consignment_request'

module UKMail
  def self.configure(&block)
    yield @config ||= Configuration.new
  end

  def self.config
    @config
  end

  class Configuration
    attr_accessor :env
    attr_accessor :api_key
    attr_accessor :postcode_data_path
    attr_accessor :service_data_path
  end

  configure do |config|
    base_path = File.dirname(__FILE__)
    config.env = :test
    config.postcode_data_path = 'Postcode.dat'
    config.service_data_path = base_path + '/uk_mail/domestic_services.yml'
  end
end
