# Encapsulates the root directory of a project
class Project

  # @param root [String] the root path of the project
  # @param searcher [FileSearcher] an object used to search for files in a given
  # directory
  def initialize(root, searcher = Dir)
    @root = root
    @searcher = searcher
  end

  attr_reader :root

  # All of the directories in the root of the project
  def directories
    content.select { |s| File.directory?(s) }.map { |s| File.basename(s) }
  end

  # All of the files in the root of the project
  def files
    content.reject { |s| File.directory?(s) }.map { |s| File.basename(s) } 
  end

  private

  attr_reader :searcher

  def content
    searcher[root + '*']
  end
end
