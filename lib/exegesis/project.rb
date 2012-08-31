# Encapsulates the root directory of a project
class Project
  extend Forwardable

  attr_reader :root

  # @param root [String] the root path of the project
  # @param searcher [FileSearcher] an object used to search for files in a given
  # directory
  def initialize(root, searcher)
    @root = root
    @searcher = searcher.new
  end

  delegate [:directories, :files] => :content

  private

  attr_reader :searcher

  def content
    searcher.search(root + '*')
  end
end
