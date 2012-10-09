module Registerable
  def self.included(base)
    base.private_class_method :new, :allocate
    base.instance_eval do
      extend  ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    def create(*args)
      retrieve(*args) || build(*args)
    end

    def retrieve(*args)
      path = build_path(*args.take(2))
      registry[path] if registry.has_key?(path)
    end

    def build(*args)
      new(*args).tap do |instance|
        registry.register! instance
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
      registry.clear!
    end

    def build_path(*args)
      parent, name = *args
      return parent if name.nil?
      File.join(parent.path, name)
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
