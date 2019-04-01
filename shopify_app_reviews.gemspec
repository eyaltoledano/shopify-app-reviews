
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "shopify_app_reviews/version"

Gem::Specification.new do |spec|
  spec.name          = "shopify_app_reviews"
  spec.version       = ShopifyAppReviews::VERSION
  spec.authors       = ["eyaltoledano"]
  spec.email         = ["eyaltoledano@me.com"]

  spec.summary       = %q{An unofficial utility providing access to Shopify App review information retrieved from the Shopify App Store.}
  spec.description   = %q{Shopify App Reviews CLI is a handy utility which provides easy terminal access to app review information retrieved from the Shopify App Store. This is an unofficial release, and is not maintained by or affiliated with Shopify in any way.}
  spec.homepage      = "https://github.com/eyaltoledano/shopify-apps-reviews-cli"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/eyaltoledano/shopify-apps-reviews-cli"
    spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
end
