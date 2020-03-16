# The Zesty.io Ruby Gem

[![Gem Version](https://badge.fury.io/rb/zesty.svg)][gem]
![CI Build](https://github.com/javierjulio/zesty-rb/workflows/CI%20Build/badge.svg)

A Ruby interface to the Zesty REST API. Requires Ruby 2.4 and up. Not all API actions are supported yet. Since the Zesty API uses mostly camelCase, this gem will handle converting to and from snake_case for you.

## Installation

Add the following to your application's Gemfile:

```ruby
gem 'zesty'
```

Or install directly with `gem install zesty`.

To try out the gem, just follow the Development section instructions as the `bin/setup` script will direct you on how to provide the necessary API info to get started.

## Usage

### Client Configuration

Request a valid token by logging in.

```ruby
token = Zesty::Auth.get_token("email", "password")
```

Then initialize a client with that token and an instance zuid.

```ruby
client = Zesty::Client.new(token, "instance_zuid")
```

### Making Requests

Make an API request with a payload in the structure documented by the Zesty REST API but using snake_case. The request payload will be converted to camelCase for you.

```ruby
head_tag = client.create_head_tag(
  resource_zuid: "instance_zuid",
  type: "link",
  attributes: {
    rel: :icon,
    href: "favicon.ico",
    "data-manual": true
  },
  sort: 1
)
```

So in the example above, `resource_zuid` gets converted to `resourceZUID` in the request payload.

### Handling Responses

Response data is in snake_case form as it converted automatically from camelCase. This includes nested objects as shown below:

```ruby
head_tag = client.get_head_tag("zuid")
pp head_tag
# {:_meta=>
#   {:timestamp=>"2019-09-24T16:39:30.571076035Z",
#    :total_results=>1,
#    :start=>0,
#    :offset=>0,
#    :limit=>1},
#  :data=>
#   {:zuid=>"zuid",
#    :type=>"link",
#    :attributes=>
#     {:"data-manual"=>true,
#      :href=>"favicon-64.png",
#      :rel=>"icon",
#      :type=>"image/png"},
#    :resource_zuid=>"resource_zuid",
#    :sort=>1,
#    :created_by_user_zuid=>"created_by_user_zuid",
#    :updated_by_user_zuid=>"created_by_user_zuid",
#    :created_at=>"2019-09-24T16:39:30.561203655Z",
#    :updated_at=>"2019-09-24T16:39:30.561210119Z"}}
```

## Development

1. `git clone https://github.com/javierjulio/zesty-rb.git`
2. Run `./bin/setup` to install dependencies and fill out API info
3. Run `./bin/console` for an interactive prompt with an authenticated client for you to experiment:

    ```ruby
    instance = client.get_instance
    instance[:data][:name]
    # => My Test Instance
    ```

All code is written in snake_case since requests and responses are converted to and from camelCase for you.

### Tests

Run `rspec` or to re-record VCR cassettes use `RECORD_MODE=all rspec`.

### Releasing

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/javierjulio/zesty-rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Zesty project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/javierjulio/zesty-rb/blob/master/CODE_OF_CONDUCT.md).

[gem]: https://rubygems.org/gems/zesty
