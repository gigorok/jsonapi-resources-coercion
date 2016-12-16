# JSONAPI::Resources::Coercion

[![Build Status](https://travis-ci.org/gigorok/jsonapi-resources-coercion.svg?branch=master)](https://travis-ci.org/gigorok/jsonapi-resources-coercion)

The gem adds type coercion to filters in [jsonapi-resources](https://github.com/cerebris/jsonapi-resources).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonapi-resources-coercion'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsonapi-resources-coercion

## Usage

To use filter's type coercions you should specify the `type` option with one of predefined types.
Supports next predefined types: integer, string, boolean, float, decimal, date_time, time, date.

```ruby
class BookResource < JSONAPI::Resource
  filter :title, type: :string
  filter :qty, type: :integer
  filter :available, type: :boolean
  filter :weight, type: :float
  filter :price, type: :decimal
  filter :published_at, type: :date_time
end
```

You can define your own type coercion. Just define singleton class method.
Example:
```ruby
class ReaderResource < JSONAPI::Resource
  filter :book, type: :book, apply: ->(records, books, _options) do
                               # books will be an array of instance of Book
                               records.where(book_ids: books.map(&:id))
                             end
  
  def self.coerce_as_book!(val)
    Book.find_by!(title: val)
  rescue ActiveRecord::RecordNotFound
    raise CoercionError
  end
end
```

If a filter cannot be coerced then bad request will be performed. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gigorok/jsonapi-resources-coercion. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

