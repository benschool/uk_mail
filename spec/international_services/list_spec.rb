require 'spec_helper'

describe UKMail::InternationalServices, '.list' do
  subject { described_class.list(params) }

  before { UKMail.config.api_key = api_key }

  let(:api_key) { ENV['TEST_API_KEY'] }

  let(:params) do
    {
      country_code: 'USA',
      weight: 5.23,
      length: 20,
      width: 10,
      height: 15,
      recipient_address_type: 'residential',
      recipient_postcode: '62236',
      doorstep_only: true
    }
  end

  context 'with valid inputs', vcr: { cassette_name: 'international_services/list/success' } do
    it 'returns a list of services' do
      expect(subject).to be_an(Array)
      expect(subject.length).to eq(1)
      expect(subject[0]).to be_a(UKMail::InternationalServices::InternationalService)
      expect(subject[0].name).to eq('Worldwide Air')
      expect(subject[0].key).to eq('101')
    end
  end

  context 'with an invalid API key', vcr: { cassette_name: 'international_services/list/invalid_api_key' } do
    let(:api_key) { '' }

    it 'raises an exception with a relevant message' do
      expect{subject}.to raise_error(UKMail::ServiceError, 'API key is invalid.')
    end
  end

  context 'with missing required params', vcr: { cassette_name: 'international_services/list/missing_required_params' } do
    before do
      params[:country_code] = nil
      params[:recipient_address_type] = nil
    end

    it 'raises an exception with a relevant message' do
      expect{subject}.to raise_error(UKMail::ServiceError, "The countryCode field is required.\nThe recipientAddressType field is required.")
    end
  end

  context 'with invalid params', vcr: { cassette_name: 'international_services/list/invalid_params' } do
    before do
      params[:country_code] = 'YYY'
    end

    it 'raises an exception with a relevant message' do
      expect{subject}.to raise_error(UKMail::ServiceError, 'Country code \'YYY\' is not a valid ISO code.')
    end
  end
end
