module Zesty
  class Request

    using Refinements::SnakeCase

    attr_reader :request_method, :url, :params, :headers

    def self.get(url, params: nil, headers: {})
      Request.new(:get, url, params, headers).perform
    end

    def self.post_form(url, params: {}, headers: {})
      Request.new(:post_form, url, params, headers).perform
    end

    def self.post(url, params: {}, headers: {})
      Request.new(:post, url, params, headers).perform
    end

    def self.put(url, params: {}, headers: {})
      Request.new(:put, url, params, headers).perform
    end

    def self.delete(url, params: {}, headers: {})
      Request.new(:delete, url, params, headers).perform
    end

    def initialize(request_method, url, params, headers)
      @request_method = request_method
      @url = url
      @params = params
      @headers = headers
    end

    def perform
      response = send(@request_method)
      process_response(response)
    end

    private

    def delete
      http_client.delete(url, params: params)
    end

    def get
      http_client.get(url, body: params)
    end

    def post_form
      http_client.post(url, form: params.transform_values { |v| HTTP::FormData::Part.new(v) })
    end

    def post
      http_client.post(url, json: params)
    end

    def put
      http_client.put(url, json: params)
    end

    def http_client
      HTTP.headers({ accept: "application/json" }.merge(headers))
    end

    def process_response(response)
      data = parse_response_body(response.to_s)

      if response.status.success?
        data
      else
        raise Error.from_response(data, response)
      end
    end

    def parse_response_body(body)
      return nil if body.strip.empty?
      json = JSON.parse(body, symbolize_names: true)
      #pp json
      json&.to_snake_case
    rescue JSON::ParserError
    end

  end
end
