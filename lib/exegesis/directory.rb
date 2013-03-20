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
  include FileSystemEntity

  delegate [:directories, :files] => :searcher
  alias children directories

  def find_directory(dirname)
    directories.select { |d| d.name == dirname }.first
  end

  def find_file(filename)
    files.select { |f| f.name == filename }.first
  end

  private

  attr_reader :searcher

  # @param parent [Directory] the root directory or project of the project
  # @param name [String] the name of the directory
  # @param searcher [FileSearcher] an object used to search for files in a given
  #    directory
  def initialize(parent, name, searcher = FileSearcher)
    @parent = parent
    @name = name
    @searcher = searcher.new(self)
  end
end
