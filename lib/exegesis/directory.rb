# class Directory
#   HAS_MANY SourceFiles
#   HAS_MANY Directories (Children)
#   HAS_A Directory (Parent)
#
# Responsibilities:
#   Finds all the files and directories at a given level of the project
#   structure, allows for recursive informing of children -- ideally in
#   parallel.
#
# Collaborators:
#   SourceFile
#   Directory
class Directory
  extend Forwardable

  # @param parent [Directory] the root directory or project of the project
  # @param name [String] the name of the directory
  # @param searcher [FileSearcher] an object used to search for files in a given
  #    directory
  def initialize(parent, name, searcher = FileSearcher)
    @parent = parent
    @name = name
    @searcher = searcher.new(path)
  end

  delegate [:directories, :files] => :searcher
  alias children directories

  attr_reader :parent

  # A system-path to the current directory
  def path
    File.join(parent.path, name)
  end

  private

  attr_reader :searcher, :name
end
