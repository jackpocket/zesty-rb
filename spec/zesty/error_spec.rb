RSpec.describe Zesty::Error do

  describe "#message" do
    it "returns the parsed message from the response body" do
      parsed = { message: "Invalid message" }
      response = double(to_s: parsed.to_json, code: 401, headers: {})

      error = described_class.from_response(parsed, response)

      expect(error.message).to eq "Invalid message"
    end

    it "returns the parsed error from the response body" do
      parsed = { error: "Error message" }
      response = double(to_s: parsed.to_json, code: 401, headers: {})

      error = described_class.from_response(parsed, response)

      expect(error.message).to eq "Error message"
    end
  end

  describe "#to_h" do
    it "returns a hash for an error containing JSON data" do
      parsed = { message: "Invalid login", status: "Unauthorized", data: nil, meta: {}, code: 401 }
      response = double(code: 401, to_s: parsed.to_json, headers: { "A" => "B" })

      error = described_class.from_response(parsed, response)

      expect(error.to_h).to eq(
        code: 401,
        message: "Invalid login",
        response_body: parsed.to_json,
        response_headers: { "A" => "B" }
      )
    end

    it "returns a hash despite unparsed data (e.g. html body)" do
      response = double(code: 500, to_s: "<html>", headers: { "A" => "B" })

      error = described_class.from_response("<html>", response)

      expect(error.to_h).to eq(
        code: 500,
        message: "<html>",
        response_body: "<html>",
        response_headers: { "A" => "B" }
      )
    end
  end

end
