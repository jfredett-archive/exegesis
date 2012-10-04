module Registerable
  def self.included(base)
    base.instance_eval do
      extend  ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    def create(parent, name, *args)
      path = File.join(parent.path, name)
      if registry.has_key?(path)
        registry[path]
      else
        new(*[parent, name, *args]).tap do |instance|
          registry.register! instance
        end
      end
    end

    def registry
      @flyweight ||= Flyweight.new do |dir|
        if dir.respond_to? :path
          dir.path
        else
          dir
        end
      end
    end

    def clear_registry!
      @flyweight.clear! if @flyweight
    end
  end

  module InstanceMethods
    def path
      build_path(parent, name)
    end

    private

    def build_path(parent, child)
      self.class.build_path(parent, child)
    end
  end
end
