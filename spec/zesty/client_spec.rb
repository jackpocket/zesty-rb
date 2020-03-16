RSpec.describe Zesty::Client do

  let(:instance_zuid) { ENV["INSTANCE_ZUID"] }
  let(:model_zuid) { ENV["MODEL_ZUID"] }
  let(:item_zuid) { "7-b29aa3e7ee-0swr1f" }

  let(:token) { Zesty::Auth.get_token(ENV["EMAIL"], ENV["PASSWORD"]) }

  let(:client) { Zesty::Client.new(token, instance_zuid) }

  describe '#get_instance' do
    it "returns an instance" do
      instance = VCR.use_cassette("zesty/instances/get_instance") do
        client.get_instance
      end

      expect(instance).to include_json({
        _meta: {
          timestamp: be_present,
          total_results: be_an(Integer),
          start: be_an(Integer),
          offset: be_an(Integer),
          limit: be_an(Integer)
        },
        data: {
          id: be_an(Integer),
          zuid: be_present,
          eco_id: nil,
          eco_zuid: nil,
          random_hash_id: be_present,
          domain: be_present,
          name: be_present,
          plan_id: be_an(Integer),
          cancelled_reason: nil,
          created_by_user_zuid: be_present,
          prefs: nil,
          blueprint_id: be_an(Integer),
          blueprint_zuid: be_present,
          requires_two_factor: be_in([0, 1]),
          legacy: be_in([true, false]),
          screenshot_url: nil,
          created_at: be_present,
          updated_at: be_present
        }
      })
    end
  end

  describe '#get_models' do
    it "returns all models" do
      models = VCR.use_cassette("zesty/instances/get_models") do
        client.get_models
      end

      expect(models).to include_json({
        _meta: {
          timestamp: be_present,
          total_results: be_an(Integer),
          start: be_an(Integer),
          offset: be_an(Integer),
          limit: be_an(Integer)
        },
        data: UnorderedArray(
          {
            zuid: be_present,
            master_zuid: be_present,
            parent_zuid: be_a(String),
            description: nil,
            label: be_present,
            type: be_present,
            name: be_present,
            sort: be_an(Integer),
            listed: be_in([true, false]),
            module: be_an(Integer),
            plugin: be_an(Integer),
            created_by_user_zuid: be_present,
            updated_by_user_zuid: be_present,
            created_at: be_present,
            updated_at: be_present
          }
        )
      })
    end
  end

  describe '#get_model' do
    it "returns a model" do
      model = VCR.use_cassette("zesty/instances/get_model") do
        client.get_model(model_zuid)
      end

      pp model
      # expect(models).to include_json({
      #   _meta: {
      #     timestamp: be_present,
      #     total_results: be_an(Integer),
      #     start: be_an(Integer),
      #     offset: be_an(Integer),
      #     limit: be_an(Integer)
      #   },
      #   data: UnorderedArray(
      #     {
      #       zuid: be_present,
      #       master_zuid: be_present,
      #       parent_zuid: be_a(String),
      #       description: nil,
      #       label: be_present,
      #       type: be_present,
      #       name: be_present,
      #       sort: be_an(Integer),
      #       listed: be_in([true, false]),
      #       module: be_an(Integer),
      #       plugin: be_an(Integer),
      #       created_by_user_zuid: be_present,
      #       updated_by_user_zuid: be_present,
      #       created_at: be_present,
      #       updated_at: be_present
      #     }
      #   )
      # })
    end
  end

  describe '#get_items' do
    it "returns all items for a model" do
      model = VCR.use_cassette("zesty/instances/get_items") do
        client.get_items(model_zuid)
      end

      pp model
      # expect(models).to include_json({
      #   _meta: {
      #     timestamp: be_present,
      #     total_results: be_an(Integer),
      #     start: be_an(Integer),
      #     offset: be_an(Integer),
      #     limit: be_an(Integer)
      #   },
      #   data: UnorderedArray(
      #     {
      #       zuid: be_present,
      #       master_zuid: be_present,
      #       parent_zuid: be_a(String),
      #       description: nil,
      #       label: be_present,
      #       type: be_present,
      #       name: be_present,
      #       sort: be_an(Integer),
      #       listed: be_in([true, false]),
      #       module: be_an(Integer),
      #       plugin: be_an(Integer),
      #       created_by_user_zuid: be_present,
      #       updated_by_user_zuid: be_present,
      #       created_at: be_present,
      #       updated_at: be_present
      #     }
      #   )
      # })
    end
  end

  describe '#get_item' do
    it "returns all items for a model" do
      item = VCR.use_cassette("zesty/instances/get_item") do
        client.get_item(model_zuid, item_zuid)
      end

      pp item
      pp item[:data][:data]
    end
  end

  describe '#update_item' do
    it "updates an item successfully" do
      model = VCR.use_cassette("zesty/instances/update_item") do
        result = client.update_item(
          model_zuid,
          item_zuid,
          data: {
            lottery_name: "New York Lotto",
            jackpot_amount: 2_300_000,
            next_drawing: Time.parse("2019-09-26 02:59:00 UTC"),
            primary_color: "#3281BB",
            jackpot: nil,
            display_order: 3
          },
          meta: {
            listed: true,
            master_zuid: item_zuid
          }
        )
      end

      pp model
    end

    it "updates and publishes an item successfully" do
      model = VCR.use_cassette("zesty/instances/update_and_publish_item") do
        result = client.update_item(
          model_zuid,
          item_zuid,
          publish: true,
          data: {
            lottery_name: "New York Lotto",
            jackpot_amount: 2_300_000,
            next_drawing: Time.parse("2019-09-26 02:59:00 UTC"),
            primary_color: "#3281BB",
            jackpot: nil,
            display_order: 3
          },
          meta: {
            listed: true,
            master_zuid: item_zuid
          }
        )
        # TODO: Once API is final the `publish: true` above will work
        # and everything below will be unnecessary
        result = client.get_item(model_zuid, item_zuid)
        version_number = result[:data][:meta][:version]
        puts "", "----",version_number,"----",""
        client.publish_item(model_zuid, item_zuid, version_number)
      end

      pp model
    end
  end

  describe '#get_head_tags' do
    it 'retrieves all head tags successfully' do
      result = VCR.use_cassette("zesty/instances/get_head_tags") do
        result = client.get_head_tags

        # result[:data].each do |d|
        #   client.delete_head_tag(d[:zuid])
        # rescue Zesty::Error => error
        #   puts ''
        #   puts "zuid #{d[:zuid]}"
        #   pp error
        #   puts ''
        # end
        # result
      end

      puts ''
      pp result
    end
  end

  describe '#create_head_tag' do
    it 'creates a head tag successfully' do
      VCR.use_cassette("zesty/instances/create_head_tag") do
        head_tag = client.create_head_tag(
          type: "link",
          attributes: {
            rel: :icon,
            type: "image/png",
            href: "favicon-64.png",
            "data-manual": true
          },
          sort: 1,
          resource_zuid: instance_zuid
        )

        pp head_tag

        client.delete_head_tag(head_tag[:data][:zuid])
      end
    end
  end

end
