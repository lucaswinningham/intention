# Intention

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/intention`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'intention'
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install intention
```

## Usage

TODO: Intention helps to ...

We might have code that looks something like this:


```rb
class Klass
  class RequiredAttributeError < StandardError; end

  DEFAULT = :default

  attr_reader :required_attribute
  attr_reader :renamed_attribute
  attr_reader :internal_attribute
  attr_reader :dumped_attribute

  def initialize(options = {})
    @options = options

    @required_attribute = options.fetch(:required_attribute) { raise RequiredAttributeError }
    @renamed_attribute = options[:not_renamed_attribute]
    @internal_attribute = options[:internal_attribute]
    @dumped_attribute = options[:dumped_attribute]
  end

  def optional_attribute
    @optional_attribute ||= options.fetch(:optional_attribute, DEFAULT) || DEFAULT
  end

  def loaded_attribute
    @loaded_attribute ||= options[:loaded_attribute]&.to_s&.downcase&.to_sym
  end

  def calculated_attribute
    @calculated_attribute ||= "#{required_attribute}: #{optional_attribute}"
  end

  def to_h
    {
      required_attribute: required_attribute,
      optional_attribute: optional_attribute,
      renamed_attribute: renamed_attribute,
      loaded_attribute: loaded_attribute,
      dumped_attribute: dump_dumped_attribute,
      calculated_attribute: calculated_attribute
    }
  end

  # Instance code

  private

  attr_reader :options

  def dump_dumped_attribute
    dumped_attribute.hash
  end

  def injected_dependency
    @injected_dependency ||= options.fetch(:injected_dependency) { Klass::Dependency.new }
  end
end

Klass.new
# => Klass::RequiredAttributeError (Klass::RequiredAttributeError)
pp Klass.new(required_attribute: :some_value).to_h
# {:required_attribute=>:some_value,
#  :optional_attribute=>:default,
#  :renamed_attribute=>nil,
#  :loaded_attribute=>nil,
#  :dumped_attribute=>3835853726419023809,
#  :calculated_attribute=>"some_value: default"}
```

Intention helps to reduce boiler plate. Let's rewrite that class:

```rb
require 'intention'

class Klass
  include Intention

  class RequiredAttributeError < StandardError; end

  required(:required_attribute, RequiredAttributeError)
  optional(:optional_attribute) { :default }
  renamed(:not_renamed_attribute, :renamed_attribute)
  internal(:internal_attribute)
  loads(:loaded_attribute, unless: proc { |x| x.nil? }) { |x| x.to_s.downcase.to_sym }
  dumps(:dumped_attribute, &:hash)
  field(:calculated_attribute) { "#{required_attribute}: #{optional_attribute}" }
  hidden(:injected_dependency) { Klass::Dependency.new }

  serializable

  # Instance code
end
```

We can even chain macros:

```rb
require 'intention'

class Klass
  include Intention.new(serializable: true)

  required(:flag).renamed(:secret_sym_flag).loads(&:to_sym).hidden
  internal(:items).optional.dumps(unless: proc { |x| x.nil? }) do |items|
    items.map { |item| Item.new item }
  end
end
```

<!-- on attribute write, still runs validations and loads -->

### Macros

TODO: Fill out below and OH! type checking stuff like `boolean` and whatnot!

#### Attribute macros

`attribute` base, optionally given

`required` must be given, error class

`default` proc ran when not given (conflicts(sp?) with `required`)

<!-- `nullable` ??? since it's different from required / optional in that a value could be given but nil -->

<!-- `coerce` if nil for required / optional or not given for optional, coerce the value before `loads` -->

`hidden` private, not serialized, good for injected dependencies

`renamed` rename incoming key

`expected`? expect the key but do nothing with / ignore it

`internal` does not get serialized in `to_h`

`loads` run incoming value serialization

`dumps` run outgoing value serialization

`field` is developed from existing

If any two are conflicting, takes the last. Examples / list ...

Values are memoized, can configure with `unmemoize` ?...

#### Class macros / module configurations

`serializable` attaches `to_h`, defaults to `false`

`strict` throws (custom) error when extra keys given, defaults to `false`

`writable` defaults to `true`

`readable` defaults to `true`

`changes` dirty changes

<!-- `changes` / `mutation(s)` defaults to `false` mounts mutation tracking through `changes` ? -->

### Customization

We can have a class whose initialization requires more than just an options hash by calling the hook:

```rb
require 'intention'

class Klass
  include Intention

  attribute(:name)

  def initialization(name, options = {})
    initialize_intention options.merge(name: name)
  end
end

Klass.new 'John Smith'
# => #<Klass:... @name="John Smith">
```

We can reference the given options hash:

```rb
require 'intention'

class Klass
  include Intention

  integer(:age)
  field(:medicare?) { age >= 65 }

  def adult?
    options_hash[:age] >= 18
  end
end

instance = Klass.new age: 30
instance.adult?
# => true
instance.medicare?
# => false
```

We can use mixins:

```rb
include 'intention'

module Serializable
  include Intention

  serializable
end

module Strict
  include Intention

  strict
end

module StrictStruct
  include Serializable
  include Strict
end

# or

module StrictStruct
  include Serializable
  
  strict
end

# then

class Klass
  include StrictStruct

  # ...
end
```

We can use inheritance:

```rb
include 'intention'

class Serializable < Intention::Base
  serializable
end

class StrictStruct < Serializable
  strict
end

class Klass < StrictStruct
  # ...
end
```

Or both:

```rb
include 'intention'

module Readonly
  include Intention

  writable false
end

module AnythingGoes
  include Intention

  strict false
end

class OpenButRigid
  include Readonly
  include AnythingGoes
end

class Klass < OpenButRigid
  # ...
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/lucaswinningham/intention>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/lucaswinningham/intention/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Intention project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lucaswinningham/intention/blob/main/CODE_OF_CONDUCT.md).
