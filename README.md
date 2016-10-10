# Sysloggable

Write your logs to syslog. Message is formatted with options and duration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sysloggable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sysloggable

## Usage

```ruby
class FooService
  include ::Sysloggable::InjectLogger(ident: 'banners_stats')

  def call
    message = "Heavy operation"
    logger.info(message, operation: 'dump', counter: counter.id, date: date) do |params|
      heavy_process!
    end
  rescue exception
    logger.fatal(exception.message, trace: exception.backtrace.join("\n"))
    raise
  end
end
```

## Development

Install Docker, Docker-Compose and DIP https://github.com/bibendi/dip

```sh
dip provision

dip rspec
```
