RSpec.describe Zesty::Auth do

  let(:auth) { described_class.new }

  describe ".get_token" do
    it "returns a token for a successful auth" do
      token = VCR.use_cassette("zesty/auth/get_token") do
        described_class.get_token(ENV["EMAIL"], ENV["PASSWORD"])
      end

      expect(token).to be_instance_of(String)
      expect(token).to_not be_empty
    end

    it "fails with invalid auth" do
      expect do
        VCR.use_cassette("zesty/auth/get_token_failure") do
          described_class.get_token(ENV["EMAIL"], "invalid")
        end
      end.to raise_error(Zesty::Error, "Invalid username or password")
    end
  end

  describe "#login" do
    it "is successful for a valid auth" do
      result = VCR.use_cassette("zesty/auth/login_successful") do
        auth.login(ENV["EMAIL"], ENV["PASSWORD"])
      end

      expect(result[:code]).to eq 200
      expect(result[:meta][:token]).to be_instance_of(String)
      expect(result[:meta][:token]).to_not be_empty
    end

    it "fails with invalid auth" do
      expect do
        VCR.use_cassette("zesty/auth/login_failure") do
          auth.login(ENV["EMAIL"], "invalid")
        end
      end.to raise_error(Zesty::Error, "Invalid username or password")
    end
  end

  describe "#verify_token" do
    it "successfully verifies a token" do
      result = VCR.use_cassette("zesty/auth/verify_token") do
        token = described_class.get_token(ENV["EMAIL"], ENV["PASSWORD"])
        auth.verify_token(token)
      end

      expect(result[:code]).to eq 200
      expect(result[:meta][:user_zuid]).to be_instance_of(String)
      expect(result[:meta][:user_zuid]).to_not be_empty
    end

    it "fails if token cannot be verified" do
      expect do
        VCR.use_cassette("zesty/auth/verify_token_failure") do
          auth.verify_token("invalid")
        end
      end.to raise_error(Zesty::Error, "No Session")
    end
  end

end
