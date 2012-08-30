class Project
  def initialize(root)
    @root = root
  end

  attr_reader :root

  def directories
    content.select { |s| File.directory?(s) }.map { |s| File.basename(s) }
  end

  def files
    content.reject { |s| File.directory?(s) }.map { |s| File.basename(s) } 
  end

  private

  def content
    Dir[@root + '*']
  end
end
