# Grenouille

[![Build Status](https://img.shields.io/circleci/project/neonichu/grenouille.svg?style=flat)](https://circleci.com/gh/neonichu/grenouille)
[![Coverage Status](https://coveralls.io/repos/neonichu/grenouille/badge.svg)](https://coveralls.io/r/neonichu/grenouille)
[![Gem Version](http://img.shields.io/gem/v/grenouille.svg?style=flat)](http://badge.fury.io/rb/grenouille)
[![Code Climate](http://img.shields.io/codeclimate/github/neonichu/grenouille.svg?style=flat)](https://codeclimate.com/github/neonichu/grenouille)

![](perfume.gif)

Grenouille uses Apple's `swift-update` tool to determine the version of Swift
used in a set of files automatically.

## Usage

You can use it on the commandline:

```bash
$ grenouille Stargate.swift 
1.2
```

or programmatically:

```ruby
su = Grenouille::SwiftUpdate.new
su.determine_version('Stargate.swift')
# 1.2
```

You can also get more detailled output:

```ruby
su.update_to_latest_swift('spec/fixtures/Blueprint.swift')
# {:report=>[{"file"=>"spec/fixtures/Blueprint.swift", "offset"=>740, "remove"=>2, "text"=>"as!"}, {"file"=>"spec/fixtures/Blueprint.swift", "offset"=>6758, "remove"=>2, "text"=>"as!"}, {"file"=>"spec/fixtures/Blueprint.swift", "offset"=>10613, "remove"=>2, "text"=>"as!"}], :output=>""}
```

The value for the `:report` key represents the result of `swift-update`, a
list of changes to perform to transform the current code to the version of
Swift supported by the used Xcode. The value for the `:output` key is the
aggregate of stdout and stderr of `swift-update`, e.g. compilation errors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grenouille'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grenouille

Note: The `swift-update` tool is a part of Xcode since 6.3, so it
needs at least that version to function.

## Contributing

1. Fork it ( https://github.com/neonichu/grenouille/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
