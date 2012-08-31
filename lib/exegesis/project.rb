# class Project
#  HAS_A Root
#  HAS_MANY Directories
#  HAS_MANY SourceFiles (files)
# 
# Responsibilities:
#  Expose properties of the root directory, Spawn the initial set of
#  directories which will recursively find all the files in the project
# 
#  The class will also wrap some of the SourceFile macros, like #join and
#  #expand_path and stuff. Think along the lines of Rails.root and the like.
# 
# Collaborators:
#  [Directory]  
#  [SourceFile]
class Project
  extend Forwardable

  attr_reader :root

  # @param root [String] the root path of the project
  # @param searcher [FileSearcher] an object used to search for files in a given
  # directory
  def initialize(root, searcher = FileSearcher)
    @root = root
    @searcher = searcher.new(root)
  end

  delegate [:directories, :files] => :searcher

  private

  attr_reader :searcher
end
