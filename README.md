# Gipull

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gipull', github: "zaru/gipull"
```

And then execute:

    $ bundle 

### Init

```
$ gipull init
AccessToken: 
```

## Usage

```
Commands:
  gipull config                             # List config
  gipull init                               # Initialized gipull
  gipull list ORG/REPO --org=one two three  # List pull-requests
```

```
$ list --org org1 org2 --repo repo1 repo2 --since 30
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zaru/gipull.

