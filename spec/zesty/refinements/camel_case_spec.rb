RSpec.describe Zesty::Refinements::CamelCase do

  using described_class

  context "single level hash" do
    let(:hash) do
      { name: "Test", first_name: "Test", random_hash_id: "1" }
    end

    it "returns a hash with camel cased keys" do
      expect(hash.to_camel_case).to eq(name: "Test", firstName: "Test", randomHashID: "1")
    end
  end

  context "hash with dasherized keys" do
    let(:hash) do
      { src: "script.js", "data-manual": true }
    end

    it "returns a hash with the dasherized keys unmodified" do
      expect(hash.to_camel_case).to eq(src: "script.js", "data-manual": true)
    end
  end

  context "nested hash" do
    let(:hash) do
      {
        _meta: {
          start: 0,
          total_results: 1,
          data: {
            id: 2,
            zuid: "3",
            random_hash_id: "6b2zbm59",
            created_by_user_zuid: "4",
            legacy: false,
            name: "test",
            cancelled_reason: nil,
            blueprint_zuid: "5",
            lang_id: '',
            requires_two_factor: 0
          }
        }
      }
    end

    it "returns a nested hash with camel cased keys" do
      expect(hash.to_camel_case).to eq(
        _meta: {
          start: 0,
          totalResults: 1,
          data: {
            ID: 2,
            ZUID: "3",
            randomHashID: "6b2zbm59",
            createdByUserZUID: "4",
            legacy: false,
            name: "test",
            cancelledReason: nil,
            blueprintZUID: "5",
            langID: '',
            requiresTwoFactor: 0
          }
        }
      )
    end
  end

end
