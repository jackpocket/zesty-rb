module Zesty
  class Error < StandardError

    attr_reader :code, :response_body, :response_headers

    class << self
      def from_response(data, response)
        message = parse_error(data) || response.to_s
        new(message, response.code, response.to_s, response.headers.to_h)
      end

      private

      def parse_error(data)
        if data.is_a?(Hash)
          data.dig(:message) || data.dig(:error)
        end
      end
    end

    def initialize(message, code, response_body, response_headers)
      super(message)
      @code = code
      @response_body = response_body
      @response_headers = response_headers
    end

    def to_h
      {
        code: code,
        message: message,
        response_body: response_body,
        response_headers: response_headers
      }
    end

  end
end
