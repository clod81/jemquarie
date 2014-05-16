jemquarie
=========

[![Build Status](https://api.travis-ci.org/clod81/jemquarie.svg)](http://travis-ci.org/clod81/jemquarie)

Jemquarie provides an easy way to interact with Macquarie ESI api. For Ruby and Ruby on Rails.

## Installation

Add this line to your application's Gemfile:

    gem 'jemquarie'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jemquarie

## Usage

## For Ruby on Rails

Create an initializer file under config/initializers

```ruby
require 'jemquarie'
Jemquarie::Jemquarie.api_key(YOUR_KEY)
```

### Import transactions


```ruby
  Jemquarie::Importer.new(username, password).retrieve(3.months.ago.to_date, Date.today)
```


## Authors ##

  * [Claudio Contin](http://github.com/clod81)

## How to contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
