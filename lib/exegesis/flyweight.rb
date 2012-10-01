# class Flyweight
#  
# Responsibilities:
#   Provide a registry for an arbitrary number of instances which need to be 
#   accessed as a single instance.
#
# Notes:
#
# Collaborators:
#   SourceFile
#   Directory
#   Project
class Flyweight
  extend Forwardable

  # Create an empty Flyweight with the given key-processing proc.
  #
  # @param key_processor [Proc] a proc which turns an instance into it's key.
  def initialize(&key_processor)
    clear!

    if block_given?
      @key_processor = key_processor
    else
      @key_processor = proc { |id| id }
    end

    self
  end

  # Register an instance in the flyweight. Throw an error if the key is already
  # used.
  #
  # @param instance [Object] the instance to register in the flyweight
  # @return [Object] the instance given
  # @raise [AlreadyRegisteredError] when trying to register the same key twice
  def register!(instance)
    raise AlreadyRegisteredError if has_key?(instance)
    register(instance)
  end

  # Register an instance in the flyweight.
  #
  # @param instance [Object] the instance to register in the flyweight
  # @return [Object] the instance given
  def register(instance)
    key = build_key(instance)
    key_registry[key] = instance
  end

  # Remove an instance (by key or instance proper) from the flyweight. Throw an
  # error if no such instance exists
  #
  # @param key_or_instance [Object] Either the key under which an instance is
  #     registered, or the instance itself.
  # @return [Object] the instance deleted from the flyweight
  # @raise [NoFlyweightEntryError] when trying to delete a key that isn't
  #     present in the flyweight
  def unregister!(key_or_instance)
    raise NoEntryError unless has_key?(key_or_instance)
    unregister(key_or_instance)
  end

  # Remove an instance from the flyweight
  #
  # @param key_or_instance [Object] Either the key under which an instance is
  #     registered, or the instance itself.
  # @return [Object] the instance deleted from the flyweight
  def unregister(key_or_instance)
    proxy_across_keytypes(:delete, key_or_instance)
  end

  # Whether the flyweight has the given key or instance registered
  #
  # @param key_or_instance [Object] Either the key under which an instance is
  #     registered, or the instance itself.
  # @return [Boolean] True if the Flyweight has the key or instance, false
  #     otherwise
  def has_key?(key_or_instance)
    proxy_across_keytypes(:has_key?, key_or_instance)
  end

  # Access the entry under the given key or instance
  #
  # NB. If, given an instance that would generate a matching key to an already
  # registered instance, but perhaps with different data, you'll get back a
  # reference to the _registered_ instance.
  #
  # @param key_or_instance [Object] The key or instance to access.
  # @return [Object, NilClass] the instance desired, or nil if it doesn't exist
  def [](key_or_instance)
    proxy_across_keytypes(:[], key_or_instance)
  end

  # Clear the Flyweight of all entries.
  def clear!
    @key_registry = {}
    self
  end
  alias reset! clear!

  def inspect
    "Flyweight<#{object_id}, items=#{@key_registry.keys.count}>"
  end

  private

  # Build a key from an instance via the key_processor
  def build_key(instance)
    @key_processor.call(instance)
  end

  # Proxy a method, aim to use the raw key first, but if that doesn't work, use
  # the build_key helper and assume you were given an instance.
  #
  # NB. This is a bit dirty, but since we don't know what types we're given, we
  # can't distinguish between key's and instance's without forcing the user to
  # specifically tell us.
  def proxy_across_keytypes(method, key)
    key_registry.send(method, key) || key_registry.send(method, build_key(key))
  end

  attr_accessor :key_registry

  # An error raised when trying to use an already used key
  class AlreadyRegisteredError < ArgumentError ; end
  # An error raised when trying to remove an unused key
  class NoEntryError < ArgumentError ; end
end

