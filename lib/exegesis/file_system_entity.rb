module FileSystemEntity
  def self.included(base)
    base.send(:include , Registerable)
    base.send(:extend  , Forwardable)
    base.send(:include , Methods)
  end

  module Methods
    def path
      File.join(parent.path, name)
    end

    def inspect
      "#{self.class.inspect}(#{path.inspect})"
    end

    attr_reader :parent, :name
    alias container parent

    def basename
      File.basename(name, ext)
    end

    def ext
      @ext || ""
    end
    alias extension ext
  end
end

