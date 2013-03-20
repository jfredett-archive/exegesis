# class FileSearcher
#
# Responsibilities:
#   Encapsulates an API for looking through a single directory of files,
#   sorting them into directories/files/whatever, and providing those path
#   lists on demand
#
# NB:
#   The aim is to isolate the minimum API with this class, so that alternative
#   source backends could potentially be written, eg -- a backend for
#   distributed sourcetrees, or w/ files in Riak or S3 or whereever
#
# Collaborators:
#   Used By:
#     Project, Directory
#   Uses:
#     Some system-level class like Dir, FileList, or Find
module Exegesis
  class FileSearcher
    # Create a new FileSearcher on the given path
    #
    # @param parent [Directory] the parent directory to search downward from
    def initialize(parent, fs_interface = File)
      @fs_interface = fs_interface
      @parent = parent
    end

    #All of the directories in the given path
    def directories
      content.
        select { |s| fs_interface.directory?(s) }.
        map    { |s| Directory.create(parent, fs_interface.basename(s)) }
    end

    #All of the files in the given path
    def files
      content.
        select { |s| fs_interface.file?(s) }.
        map    { |s| SourceFile.create(parent, fs_interface.basename(s)) }
    end

    #All of the content from the given path
    def content
      Dir[File.join(parent.path, '*')]
    end

    def inspect
      "FileSearcher(#{parent.path.inspect})"
    end

    private

    attr_reader :parent, :fs_interface
  end
end
