require 'accountview/api_methods'
require 'accountview/utils/hash'

module Accountview
  class Client
    API_VERSION = 'v3'
    DEFAULT_PAGESIZE = 200
    # Sets or gets the api_version to be used in API calls
    #
    # @return [String]
    attr_accessor :api_version

    # Sets or gets the division id to be used in API calls
    #
    # @return [String]
    attr_accessor :company_id

    def initialize(oauth_client, opts = {})
      @api_version = API_VERSION
      @oauth_client = oauth_client
      @options = opts

      @company_id = opts[:company_id]
      self.company_id = @company_id
    end

    def set_current_company(company_id = nil)
      if company_id
        self.company_id = company_id
      else
        self.company_id = self.companies.first['Id'] if self.companies.any?
      end
    end

    # Make a custom request
    def custom_request(uri, opts = {})
      get uri, opts
    end

    def check_required_parameters(required, params)
      params.fetch(required) { raise ArgumentError, "Missing required parameters: #{required - params.keys}" if (required-params.keys).size > 0 }
    end

    private

    def get(path, headers = {})
      begin
        @oauth_client.refresh_token! if @oauth_client.access_token.expired?
        res = extract_response_body raw_get(path, headers)
      rescue
        @oauth_client.refresh_token!
        res = extract_response_body raw_get(path, headers)
      end
    end

    def raw_get(path, headers = {})
      headers.deep_merge!(headers: { 'x-company' => "#{self.company_id}" }) if self.company_id
      headers.deep_merge!(headers: { 'User-Agent' => "Accountview Api gem",
             'Accept' => 'application/json' })

      uri = "api/#{@api_version}#{path}"

      @oauth_client.access_token.get(uri, headers)
    end

    def post(path, body = '', headers = {})
      extract_response_body raw_post(path, body, headers)
    end

    def raw_post(path, body = '', headers = {})
      headers.merge!(headers: { 'User-Agent' => "Accountview Api gem" })
      uri = "#{@api_version}#{path}"
      @oauth_client.access_token.post(uri, body, headers)
    end

    def delete(path, headers = {})
      extract_response_body raw_delete(path, headers)
    end

    def raw_delete(path, headers = {})
      headers.merge!(headers: { 'User-Agent' => "Accountview Api gem" })
      uri = "#{@api_version}#{path}"
      @oauth_client.access_token.delete(uri, headers)
    end

    def extract_response_body(resp)
      resp.nil? || resp.body.nil? ? {} : JSON.parse(resp.body)
    end
  end
end
