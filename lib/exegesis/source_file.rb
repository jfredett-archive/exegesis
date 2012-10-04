# class SourceFile
#   HAS_A Extension
#   HAS_A Path
#   HAS_A Base Name
#   HAS_MANY SourceFiles (Dependencies)
#
# Responsibilities:
#   Represents a sourcefile on disk, providing access to it's file-system
#   related information as well as internal information based on the language.
#
# Notes:
#   This will likely work w/ an inheritance heirarchy for each programming
#   language. Mostly it will be one-level deep, but in the case where a
#   subsequent language forms a superset/subset, deeper inheritance may occur
#   (similarly we might have a module for shared subsets, etc).
#
# Collaborators:
#   SourceFile
#   SourceFileFactory       -- to build the appropriate subclass based on file extenstion
class SourceFile
  include FileSystemEntity

  def initialize(parent, name)
    raise ArgumentError, "parent must be a directory" unless parent.is_a?(Directory)

    @ext = File.extname(name)
    @name = name
    @parent = parent
    @dependencies = []
  end

  def content
    File.read(path)
  end

  attr_reader :dependencies
  def depends_on(file)
    raise InvalidDependency unless file.is_a?(SourceFile)
    @dependencies << file
  end
end

class InvalidDependency < StandardError ; end
