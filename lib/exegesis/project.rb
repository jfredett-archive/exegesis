class Project
  def initialize(root, searcher = Dir)
    @root = root
    @searcher = searcher
  end

  attr_reader :root

  def directories
    content.select { |s| File.directory?(s) }.map { |s| File.basename(s) }
  end

  def files
    content.reject { |s| File.directory?(s) }.map { |s| File.basename(s) } 
  end

  private

  attr_reader :searcher

  def content
    searcher[root + '*']
  end
end
