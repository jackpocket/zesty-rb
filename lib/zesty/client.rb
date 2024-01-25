module Zesty
  class Client

    API_URLS = {
      get_instance: "https://accounts.api.zesty.io/v1/instances/%{instance_zuid}",
      get_models: "https://%{instance_zuid}.api.zesty.io/v1/content/models",
      get_model: "https://%{instance_zuid}.api.zesty.io/v1/content/models/%{model_zuid}",
      get_items: "https://%{instance_zuid}.api.zesty.io/v1/content/models/%{model_zuid}/items",
      get_item: "https://%{instance_zuid}.api.zesty.io/v1/content/models/%{model_zuid}/items/%{item_zuid}",
      create_item: "https://%{instance_zuid}.api.zesty.io/v1/content/models/%{model_zuid}/items",
      update_item: "https://%{instance_zuid}.api.zesty.io/v1/content/models/%{model_zuid}/items/%{item_zuid}",
      get_head_tags: "https://%{instance_zuid}.api.zesty.io/v1/web/headtags",
      create_head_tag: "https://%{instance_zuid}.api.zesty.io/v1/web/headtags",
      delete_head_tag: "https://%{instance_zuid}.api.zesty.io/v1/web/headtags/%{head_tag_zuid}"
    }

    using Refinements::CamelCase

    attr_reader :instance_zuid

    def initialize(token, instance_zuid, **options)
      @token = token
      @instance_zuid = instance_zuid
      @options = options
    end

    def get_instance
      Request.get(url_for(:get_instance), headers: { authorization: "Bearer #{@token}" })
    end

    def get_models
      Request.get(url_for(:get_models), headers: { authorization: "Bearer #{@token}" })
    end

    def get_model(model_zuid)
      Request.get(url_for(:get_model, model_zuid: model_zuid), headers: { authorization: "Bearer #{@token}" })
    end

    def get_items(model_zuid)
      Request.get(url_for(:get_items, model_zuid: model_zuid), headers: { authorization: "Bearer #{@token}" })
    end

    def get_item(model_zuid, item_zuid)
      Request.get(url_for(:get_item, model_zuid: model_zuid, item_zuid: item_zuid), headers: { authorization: "Bearer #{@token}" })
    end

    def create_item(model_zuid, parent_zuid="0", data:, web: {})
      Request.post(
        url_for(:create_item, model_zuid: model_zuid, parent_zuid: parent_zuid),
        params: {
          web: web.merge(parentZUID: parent_zuid).to_camel_case,
          data: data
        },
        headers: {
          authorization: "Bearer #{@token}"
        }
      )
    end

    def update_item(model_zuid, item_zuid, publish: false, data:, meta:, web: {})
      # TODO: include `publish: publish` in `url_for` line once API is announced
      # TODO: add `?publish=%{publish}` to API_URLS `:update_item`
      Request.put(
        url_for(:update_item, model_zuid: model_zuid, item_zuid: item_zuid), # publish: publish),
        params: {
          data: data,
          meta: meta.to_camel_case,
          web: web.to_camel_case
        },
        headers: {
          authorization: "Bearer #{@token}"
        }
      )
    end

    # [LEGACY] This will be replaced by `update_item(... publish: true)`
    def publish_item(model_zuid, item_zuid, version_number)
      Request.post(
        "https://svc.zesty.io/sites-service/#{instance_zuid}/content/items/#{item_zuid}/publish-schedule",
        params: {
          version_num: version_number
        },
        headers: {
          authorization: "Bearer #{@token}",
          'X-Auth': @token
        }
      )
    end

    def get_head_tags
      Request.get(url_for(:get_head_tags), headers: { authorization: "Bearer #{@token}" })
    end

    def create_head_tag(type:, attributes:, sort:, resource_zuid:)
      Request.post(
        url_for(:create_head_tag),
        params: {
          type: type,
          attributes: attributes,
          sort: sort,
          resource_zuid: resource_zuid
        }.to_camel_case,
        headers: {
          authorization: "Bearer #{@token}"
        }
      )
    end

    def delete_head_tag(head_tag_zuid)
      Request.delete(url_for(:delete_head_tag, head_tag_zuid: head_tag_zuid), headers: { authorization: "Bearer #{@token}" })
    end

    private

    def url_for(name, **data)
      format(API_URLS.fetch(name), data.merge(instance_zuid: instance_zuid))
    end

  end
end
