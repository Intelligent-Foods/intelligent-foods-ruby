# IntelligentFoods

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add intelligent-foods-ruby

If bundler is not being used to manage dependencies, install the gem by
executing:

    $ gem install intelligent-foods-ruby

## Getting Started

### Setup Work

```
require "intelligent-foods-ruby"

IntelligentFoods.configure do |config|
  config.client_id = "XXXXXX"
  config.client_secret = "YYYYYY"
  config.environment = "preview"
end
```

### Authentication

```
@client = IntelligentFoods.client
@client.authenticate!
```

### Usage

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Testing

For `rspec`, add the following line to your `spec/rails_helper.rb` or
`spec/spec_helper` if `rails_helper` does not exist:

```
require "intelligent_foods/rspec"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/[USERNAME]/intelligent-foods-ruby. This project is intended
to be a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [code of conduct](https://github.com/[USERNAME]/intelligent-foods-ruby/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the IntelligentFoods project's codebases, issue
trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/intelligent-foods-ruby/blob/main/CODE_OF_CONDUCT.md).
