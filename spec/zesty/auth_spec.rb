RSpec.describe Zesty::Auth do

  let(:auth) { described_class.new }

  it "is successful for a valid auth" do
    result = VCR.use_cassette("zesty/login_successful") do
      auth.login(ENV["EMAIL"], ENV["PASSWORD"])
    end

    expect(result[:code]).to eq 200
    expect(result[:meta][:token]).to be_instance_of(String)
    expect(result[:meta][:token]).to_not be_empty
  end

  it "returns just a token for a successful auth" do
    token = VCR.use_cassette("zesty/get_token") do
      described_class.get_token(ENV["EMAIL"], ENV["PASSWORD"])
    end

    expect(token).to be_instance_of(String)
    expect(token).to_not be_empty
  end

  it "fails for invalid auth" do
    expect do
      VCR.use_cassette("zesty/login_failure") do
        auth.login(ENV["EMAIL"], "invalid")
      end
    end.to raise_error(Zesty::Error, "Invalid username or password")
  end

  it "verifies a token" do
    result = VCR.use_cassette("zesty/verify_token") do
      token = auth.login(ENV["EMAIL"], ENV["PASSWORD"])[:meta][:token]
      auth.verify_token(token)
    end

    expect(result[:code]).to eq 200
    expect(result[:meta][:user_zuid]).to be_instance_of(String)
    expect(result[:meta][:user_zuid]).to_not be_empty
  end

end
