# ShopifyAppReviews CLI

Shopify App Reviews CLI is a handy utility which provides easy terminal access to app review information retrieved from the Shopify App Store. This is an unofficial release, and is not maintained by or affiliated with Shopify in any way.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shopify_app_reviews'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shopify_app_reviews

## Usage

To start the CLI, navigate to the project root and run:

    $ bin/shopify_app_reviews

You'll be required to supply the program with a Shopify app name or app URL from the Shopify App Store.

If a Shopify App is found, you can  access its latest 10 reviews using
`latest reviews`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eyaltoledano/shopify_app_reviews. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ShopifyAppReviews project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/shopify_app_reviews/blob/master/CODE_OF_CONDUCT.md).
