class Directory
  extend Forwardable

  def initialize(parent, name, searcher = FileSearcher)
    raise 'parent must be a directory' unless parent.is_a?(Directory)
    @parent = parent
    @name = name
    @searcher = searcher.new(parent.path, name)
  end

  delegate [:directories, :files] => :searcher

  attr_reader :parent

  def path 
    File.join(parent.path, name) 
  end

  private 

  attr_reader :searcher, :name
end
