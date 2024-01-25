RSpec.describe Zesty::Client do

  let(:instance_zuid) { ENV["INSTANCE_ZUID"] }
  let(:model_zuid) { ENV["MODEL_ZUID"] }
  let(:item_zuid) { "7-b29aa3e7ee-0swr1f" }
  let(:parent_zuid) { "6-948fb2a6a4-hzsqk1" }

  let(:token) { Zesty::Auth.get_token(ENV["EMAIL"], ENV["PASSWORD"]) }

  let(:client) { Zesty::Client.new(token, instance_zuid) }

  # TODO: split into API objects: client.account, client.instance, client.media
  # TODO: Update test to create/delete instances. This is supported by the API:
  # https://accounts-api.zesty.org/?version=latest#3803b0f6-3481-19d7-e211-1db25f8c1027

  describe '#get_instance' do
    it "returns an instance" do
      instance = VCR.use_cassette("zesty/instances/get_instance") do
        client.get_instance
      end

      expect(instance).to include_json({
        _meta: {
          timestamp: TIMESTAMP_REGEX,
          total_results: be_an(Integer),
          start: be_an(Integer),
          offset: be_an(Integer),
          limit: be_an(Integer)
        },
        data: {
          id: be_an(Integer),
          zuid: be_a(String),
          eco_id: nil,
          eco_zuid: nil,
          random_hash_id: /([a-zA-Z0-9]+)/,
          domain: be_a(String),
          name: be_a(String),
          plan_id: be_an(Integer),
          cancelled_reason: nil,
          created_by_user_zuid: be_a(String),
          prefs: nil,
          blueprint_id: be_an(Integer),
          blueprint_zuid: be_a(String),
          requires_two_factor: be_an(Integer),
          legacy: /true|false/,
          screenshot_url: be_a(String),
          created_at: TIMESTAMP_REGEX,
          updated_at: TIMESTAMP_REGEX
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
          timestamp: TIMESTAMP_REGEX,
          total_results: be_an(Integer),
          start: be_an(Integer),
          offset: be_an(Integer),
          limit: be_an(Integer)
        },
        data: UnorderedArray(
          {
            zuid: be_a(String),
            master_zuid: be_a(String),
            parent_zuid: be_a(String),
            description: nil,
            label: be_a(String),
            type: be_a(String),
            name: be_a(String),
            sort: be_an(Integer),
            listed: /true|false/,
            module: be_an(Integer),
            plugin: be_an(Integer),
            created_by_user_zuid: be_a(String),
            updated_by_user_zuid: be_a(String),
            created_at: TIMESTAMP_REGEX,
            updated_at: TIMESTAMP_REGEX
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
      #     timestamp: TIMESTAMP_REGEX,
      #     total_results: be_an(Integer),
      #     start: be_an(Integer),
      #     offset: be_an(Integer),
      #     limit: be_an(Integer)
      #   },
      #   data: UnorderedArray(
      #     {
      #       zuid: be_a(String),
      #       master_zuid: be_a(String),
      #       parent_zuid: be_a(String),
      #       description: nil,
      #       label: be_a(String),
      #       type: be_a(String),
      #       name: be_a(String),
      #       sort: be_an(Integer),
      #       listed: /true|false/,
      #       module: be_an(Integer),
      #       plugin: be_an(Integer),
      #       created_by_user_zuid: be_a(String),
      #       updated_by_user_zuid: be_a(String),
      #       created_at: TIMESTAMP_REGEX,
      #       updated_at: TIMESTAMP_REGEX
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
      #     timestamp: TIMESTAMP_REGEX,
      #     total_results: be_an(Integer),
      #     start: be_an(Integer),
      #     offset: be_an(Integer),
      #     limit: be_an(Integer)
      #   },
      #   data: UnorderedArray(
      #     {
      #       zuid: be_a(String),
      #       master_zuid: be_a(String),
      #       parent_zuid: be_a(String),
      #       description: nil,
      #       label: be_a(String),
      #       type: be_a(String),
      #       name: be_a(String),
      #       sort: be_an(Integer),
      #       listed: /true|false/,
      #       module: be_an(Integer),
      #       plugin: be_an(Integer),
      #       created_by_user_zuid: be_a(String),
      #       updated_by_user_zuid: be_a(String),
      #       created_at: TIMESTAMP_REGEX,
      #       updated_at: TIMESTAMP_REGEX
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

  describe '#create_item' do
    it "creates an item successfully" do
      model = VCR.use_cassette("zesty/instances/create_item") do
        result = client.create_item(
          model_zuid,
          parent_zuid,
          web: {
            metaTitle: "Example Only",
            metaLinkText: "Example Link Text",
            pathPart: "example-only"
          },
          data: {
            event_details_title: "postman test only",
            charity_name: "postman test",
            sweepstakes_datetime: "September 28 5PM",
            event_entry_start_date: "August 15, 2023",
            event_entry_start_time: "3:00:00 PM",
            event_stream_start_date: "December 21, 2023",
            event_stream_start_time: "2:59:59 PM",
            event_drawing_date: "December 23, 2034",
            event_drawing_time: "5:00:00 PM",
            event_reveal_date: "December 24, 2034",
            event_reveal_time: "6:00:00 PM",
            donation_increment_title: "two",
            donation_increment_amount: 2,
            drawing_1_winning_pattern_name: "Line",
            drawing_1_winning_pattern_description: "five (5) Clicked Numbers in any straight line on a Card",
            drawing_1_prize_amount: 50,
            drawing_1_prize_text: "fifty",
            drawing_2_winning_pattern_name: "Stamp",
            drawing_2_winning_pattern_description: "sixteen (16) Clicked Numbers around the edges of a Card",
            drawing_2_prize_amount: 30,
            drawing_2_prize_text: "thirty",
            drawing_3_winning_pattern_name: "Corners",
            drawing_3_winning_pattern_description: "twenty-five (25) Clicked Numbers on a Card",
            drawing_3_prize_amount: 100,
            drawing_3_prize_text: "one hundred",
            drawings_total_prize_text: "five thousand five hundred fifty",
            drawings_total_prize_amount: "5,550"
          }
        )
      end

      pp model
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
