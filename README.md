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

`attribute` defines a public reader and public writer for the given attribute name. When the defined writer method is called, it takes the value and calls a middleware chain which will return the new value to be stored as the instance variable with the same name as the attribute.
A value for the attribute can be optionally given at initialization. Iff a key with the same name as the attribute exists in the given initialization input, it will call the accessor writer with the given attribute value.

```rb
Attribute = Intention.new do
  attribute(:pub)
end

instance = Attribute.new

instance.respond_to?(:pub)
# => true
instance.respond_to?(:pub=)
# => true
instance.pub
# => nil
instance.pub = 1
instance.pub
# => 1

Attribute.new(pub: 2).pub
# => 2
```

##### Access

###### accessible

`accessible` sets the reader (if exists) to public and sets the writer (if exists) to public. This is the default behavior for `attribute`.

###### inaccessible

`inaccessible` sets the reader (if exists) to private and sets the writer (if exists) to private.

```rb
Inaccessible = Intention.new do
  inaccessible(:priv)
end

instance = Inaccessible.new

instance.respond_to?(:priv)
# => false
instance.respond_to?(:priv=)
# => false
instance.respond_to?(:priv, true)
# => true
instance.respond_to?(:priv=, true)
# => true

instance.__send__(:priv)
# => nil
instance.__send__(:priv=, 1)
instance.__send__(:priv)
# => 1

Inaccessible.new(priv: 2).__send__(:priv)
# => 2
```

###### readonly

`readonly` sets the reader (if exists) to public, sets the writer (if exists) to private.

```rb
Readonly = Intention.new do
  readonly(:readable)
end

instance = Readonly.new

instance.respond_to?(:readable)
# => true
instance.respond_to?(:readable=)
# => false
instance.respond_to?(:readable=, true)
# => true

instance.readable
# => nil
instance.__send__(:readable=, 1)
instance.readable
# => 1

Readonly.new(readable: 2).readable
# => 2
```

###### writeonly

`writeonly` sets the reader (if exists) to private, sets the writer (if exists) to public.

```rb
Writeonly = Intention.new do
  writeonly(:writable)
end

instance = Writeonly.new

instance.respond_to?(:writable)
# => false
instance.respond_to?(:writable=)
# => true
instance.respond_to?(:writable, true)
# => true

instance.__send__(:writable)
# => nil
instance.writable = 1
instance.__send__(:writable)
# => 1

Writeonly.new(writable: 2).__send__(:writable)
# => 2
```

###### ignore_reader

`ignore_reader` undefines the reader.

```rb
IgnoreReader = Intention.new do
  ignore_reader(:unreadable)
end

instance = IgnoreReader.new

instance.respond_to?(:unreadable)
# => false
instance.respond_to?(:unreadable=)
# => true
instance.respond_to?(:unreadable, true)
# => false

instance.instance_variable_get(:@unreadable)
# => nil
instance.unreadable = 1
instance.instance_variable_get(:@unreadable)
# => 1

IgnoreReader.new(unreadable: 2).instance_variable_get(:@unreadable)
# => 2
```

###### ignore_writer

`ignore_writer` undefines the writer.

```rb
IgnoreWriter = Intention.new do
  ignore_writer(:unwritable)
end

instance = IgnoreWriter.new

instance.respond_to?(:unwritable)
# => true
instance.respond_to?(:unwritable=)
# => false
instance.respond_to?(:unwritable=, true)
# => false

instance.unwritable
# => nil
instance.instance_variable_set(:@unwritable, 1)
instance.unwritable
# => 1

IgnoreWriter.new(unwritable: 2).unwritable
# => 2
```

###### ignore_accessor

`ignore_accessor == ignore_reader.ignore_writer` calls `ignore_reader` and `ignore_writer`.

```rb
IgnoreAccessor = Intention.new do
  ignore_accessor(:illiterate)
end

instance = IgnoreAccessor.new

instance.respond_to?(:illiterate)
# => false
instance.respond_to?(:illiterate=)
# => false
instance.respond_to?(:illiterate, true)
# => false
instance.respond_to?(:illiterate=, true)
# => false

instance.instance_variable_get(:@illiterate)
# => nil
instance.instance_variable_set(:@illiterate, 1)
instance.instance_variable_get(:@illiterate)
# => 1

IgnoreAccessor.new(illiterate: 2).instance_variable_get(:@illiterate)
# => nil
```

##### Ingestion

###### loads

`loads(&block)` takes the given block and adds a entry in the accessor writer middleware chain. The given block will be called whenever the accessor writer is called and will be given the current value in the accessor writer middleware chain. The new accessor writer middleware chain value will be the return value of the given block. The given block will not be given any arguments? Not even the current instance?

Each use of `loads` will add a new writer middleware chain entry.

```rb
Loads = Intention.new do
  loads(:loaded) { :was_loaded }
end

Loads.new.loaded
# => nil
Loads.new(loaded: nil).loaded
 #=> :was_loaded
Loads.new(loaded: :given).loaded
 #=> :was_loaded
```

###### default

`default(&block)` takes the given block and observes when a key with the same name as the attribute does not exist in the given initialization input. At this point, it will call the accessor writer with the return value of the block. The given block will not be given any arguments? Not even the current instance?

Multiple uses of `default` will only observe the last usage.

```rb
Default = Intention.new do
  default(:defaulted) { :was_defaulted }
end

Default.new.defaulted
# => :was_defaulted
Default.new(defaulted: nil).defaulted
# => nil
Default.new(defaulted: :given).defaulted
# => :given
```

Note: because `default` is activated when
> a key with the same name as the attribute does not exist in the given initialization input
any configurations for the attribute which hook into the accessor writer middleware chain will also be activated: `loads`, `null`, etc. For example:

```rb
DefaultAndLoads = Intention.new do
  default(:defaulted_and_loaded) { :was_defaulted }.loads { :was_loaded }
end

DefaultAndLoads.new.defaulted_and_loaded
# => :was_loaded
DefaultAndLoads.new(defaulted_and_loaded: nil).defaulted_and_loaded
 #=> :was_loaded
DefaultAndLoads.new(defaulted_and_loaded: :given).defaulted_and_loaded
 #=> :was_loaded
```

###### null

`null(&block)` takes the given block and adds an entry in the accessor writer middleware chain. The given block will be called if the current value in the accessor writer middleware chain is `nil`. The new writer middleware chain value will be the return value of the given block. The given block will not be given any arguments? Not even the current instance?

Each use of `null` will add a new writer middleware chain entry. This is to handle when intermediate writer middleware chain entries set the current value in the chain to `nil`.

```rb
Null = Intention.new do
  null(:nulled) { :was_nulled }
end

Null.new.nulled
# => nil
Null.new(nulled: nil).nulled
# => :was_nulled
Null.new(nulled: :given).nulled
# => :given

NullAndLoads = Intention.new do
  null(:nulled_and_loaded) { :was_nulled }.loads { nil }.null { :was_nulled_too }
end

NullAndLoads.new.nulled_and_loaded
# => nil
NullAndLoads.new(nulled_and_loaded: nil).nulled_and_loaded
# => :was_nulled_too
NullAndLoads.new(nulled_and_loaded: :given).nulled_and_loaded
# => :was_nulled_too
```

###### coerce

`coerce(&block) == default(&block).null(&block)` takes the given block and calls `default` and `null` with the same block.

```rb
Coerce = Intention.new do
  coerce(:coerced) { :was_coerced }
end

Coerce.new.coerced
# => :was_coerced
Coerce.new(coerced: nil).coerced
# => :was_coerced
Coerce.new(coerced: :given).coerced
# => :given
```

This can be useful when combined with `loads`:

```rb
class Item
  attr_reader :number

  def initialize(number)
    @number = number
  end
end

Collection = Intention.new do
  coerce(:items) { [] }.loads { |items| items.map(&Item.method(:new)) }
end

Collection.new.items
# => []
Collection.new(items: nil).items
# => []
Collection.new(items: [1, 2, 3]).items
# => [#<Item:0x... @number=1>, #<Item:0x... @number=2>, #<Item:0x... @number=3>]
```

##### Validation

TODO: Add instance setter examples where necessary, both above and below.

###### required

`required!(CustomError = RequiredAttributeError)` takes the optionally given error class (defaults to `Intention::Validation::RequiredAttributeError`) and observes when a key with the same name as the attribute does not exist in the given initialization input, at which point it raises the error class.

Multiple uses of `required!` will only observe the last usage.

```rb
Required = Intention.new do
  required!(:needed)
end

Required.new
# Traceback ...
# Intention::Validation::RequiredAttributeError
Required.new(needed: nil).needed
# => :was_needed
Required.new(needed: :given).needed
# => :given
```

###### reject

`reject!(CustomError = RejectedAttributeError, &block)` takes the optionally given error class (defaults to `Intention::Validation::RequiredAttributeError`) and the required given block and adds an entry in the accessor writer middleware chain. If the current value in the accessor writer middleware chain matches the return value of called given block, it raises the error class. The given block is called with the current value in the chain.

Each use of `reject!` will add a new writer middleware chain entry. This is to add the ability to reject the value in different ways with different errors.

```rb
Reject = Intention.new do
  class CannotBeZeroError < StandardError; end
  class CannotBeNegativeError < StandardError; end

  reject!(:rejected, CannotBeNegativeError, &:negative?).reject!(CannotBeZeroError, &:zero?)
end

Reject.new.rejected
# => nil
Reject.new(rejected: 1).rejected
# => 1
Reject.new(rejected: 0)
# Traceback ...
# CannotBeZeroError
Reject.new(rejected: -1)
# Traceback ...
# CannotBeNegativeError
```

###### allow

`allow!(CustomError = AllowedAttributeError, &block)` takes the optionally given error class (defaults to `Intention::Validation::RequiredAttributeError`) and the required given block and adds an entry in the accessor writer middleware chain. If the current value in the accessor writer middleware chain does not match the return value of called given block, it raises the error class. The given block is called with the current value in the chain.

Each use of `allow!` will add a new writer middleware chain entry. This is to add the ability to allow the value in different ways with different errors.

Note: `allow!` is more restrictive than `reject!` as _all_ conditions need to be met for an error not to be raise whereas for `reject!`, an error is only raised iff _any_ condition is met.

```rb
Allow = Intention.new do
  class CannotBeEmptyError < StandardError; end
  class LengthUpperLimitError < StandardError; end

  allow!(:allowed, CannotBeEmptyError) { |value| !value.empty? }
    .allow!(LengthUpperLimitError) { |value| value.length < 3 }
end

Allow.new.allowed
# => nil
Allow.new(allowed: 'hi').allowed
# => "hi"
Allow.new(allowed: [1, 2, 3])
# Traceback ...
# LengthUpperLimitError
Allow.new(allowed: '')
# Traceback ...
# CannotBeEmptyError
```

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
