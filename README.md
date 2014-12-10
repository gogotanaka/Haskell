# Haskell On Ruby

```rb
require 'haskell'

# ex1
puts "It's totally Ruby"
hs_result = haskell {"

"}
puts "You've got #{hs_result} from haskell"


# ex2: (Ruby 2.1.0+)


# ex3: (Ruby 2.1.0+)

```

## Feature
### Typed method can coexist with non-typed method

```ruby
# It's totally OK!!
class MyClass
  def sum(x, y)
    x + y
  end
  type Numeric, Numeric >= Numeric, :sum

  def wrong_sum(x, y)
    'string'
  end
end
```

### Duck typing

```ruby

class MyClass
  def foo(any_obj)
    1
  end
  type Any >= Numeric, :foo
end

# It's totally OK!!
MyClass.new.foo(1)
# It's totally OK!!
MyClass.new.foo('str')
```

## Installation

gem install haskell or add gem 'haskell' to your Gemfile.

This gem requires Ruby 2.0.0+.

### Contributing

Fork it ( https://github.com/[my-github-username]/haskell/fork )

Create your feature branch (`git checkout -b my-new-feature`)

    $ bundle install --path vendor/bundle

Commit your changes (`git commit -am 'Add some feature'`)

    $ bundle exec rake test

    > 5 runs, 39 assertions, 0 failures, 0 errors, 0 skips

Push to the branch (`git push origin my-new-feature`)

Create a new Pull Request

## Credits
[@chancancode](https://github.com/chancancode) first brought this to my attention. I've stolen some idea from him.
