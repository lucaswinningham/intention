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
  attr_reader :withheld_attribute
  attr_reader :dumped_attribute

  def initialize(options = {})
    @options = options

    @required_attribute = options.fetch(:required_attribute) { raise RequiredAttributeError }
    @renamed_attribute = options[:not_renamed_attribute]
    @withheld_attribute = options[:withheld_attribute]
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

  loads(:loaded_attribute, unless: proc(&:nil?)) { |x| x.to_s.downcase.to_sym }
  dumps(:dumped_attribute, &:hash)
  withheld(:withheld_attribute)

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

  required(:flag).renamed(:secret_sym_flag).hidden

  coerce(:items) { [] }.loads(unless: proc(&:nil?)) { |items|
    items.map { |item| Item.new item }
  }.dumps(unless: proc(&:nil?)) { |items|
    items.map(&:to_h)
  }
end
```

<!-- on attribute write, still runs validations and loads -->

### Macros

TODO: Fill out below and OH! type checking stuff like `boolean` and whatnot! (hmm, well maybe not...)

#### Attribute macros

`attribute` base, optional, public getter, public setter, loads / dumps identity, uses name (not renamed)

##### Access

`accessible` sets reader (if exists) to public, sets writer (if exists) to public

`inaccessible` sets reader (if exists) to private, sets writer (if exists) to private

`readonly` sets reader (if exists) to public, sets writer (if exists) to private

`writeonly` sets reader (if exists) to private, sets writer (if exists) to public

`ignore_reader` undefines reader

`ignore_writer` undefines writer

`ignore == ignore_reader.ignore_writer`

##### Ingestion

`default(&block)` supplies a default value via return value of the block when the attribute is not given at initialization. Block is optional and defaults to an empty block which returns `nil`.
can use previously processed instance attributes in proc for determining default value as it is passed the instance???

`null(&block)` supplies a default value via return value of the block when the given attribute value at initialization is `nil`. Block is optional and defaults to an empty block which returns `nil`.

`coerce(&block) == default(&block).null(&block)` supplies a default value via return value of the block when the given attribute value at initialization is `nil` or when the attribute value is not given at initialization. Block is optional and defaults to an empty block which returns `nil`.

##### Validation

`required!(Error, &block)` declares that the attribute must be given at initialization. Takes an optional error class as an argument. Block is optional and defaults to a block that returns true. The block is ran when the attribute is not given at initialization. If the block returns a truthy value, the given error class (or a default supplied error class) will be raised.

##### Foo

`renamed` rename incoming key

`alias?` alias attribute

`loads` run incoming value serialization

`dumps` run outgoing value serialization for `to_h` (if applicable)

`withheld` does not get serialized in `to_h`

`hidden == inaccessible.withheld`

`expected`? `ignore`, `withheld: true`, expect the key but do nothing with / ignore it, for bypassing `strict!`.

`field` proc that's given to `default`, `hidden`, good for injected dependencies / calculated attributes -- as in attributes that will never be given values in the input hash. Note: If a value _is_ given in the input hash, that value will be assigned as the value for the attribute (good for dependency injection testing).

If any two are conflicting, takes the last. Examples / list ... like `default.required` ?...

Values are memoized, can configure with `unmemoize` ?...

#### Class macros / module configurations

`serializable` attaches `to_h`, defaults to `false`

`strict!` throws an error when extra keys given, defaults to `false`

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
    intention.initialization.call(input: options.merge(name: name), instance: self)
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

  def adult?
    intention_input_hash[:age] >= 18
  end
end

instance = Klass.new age: 30
instance.adult?
# => true
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

# or

class StrictStruct < Intention::Base
  serializable
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

  writer false
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
