#class DirectoryStructure
  #def initialize
    #@base_directory = BaseDirectory.new('./')
    #yield
  #end

  #def src(name = nil)
    #@src_dir ||= name
  #end

  #def obj(name = nil)
    #@obj_dir ||= name
  #end

  #def test(name = nil)
    #@test_dir ||= name
  #end

  #def bin(name = nil)
    #@bin_dir ||= name
  #end
#end

class Project
  #include Rake::DSL

  #def initialize(name, searcher = FileSearcher)
    #@name = name
    #@searcher = searcher
    #yield if block_given?
  #end

  #def compiler(binary, options)
    ##ensure compiler exists, responds well to all options passed for a trivial
    ##program
  #end

  ##scaffolding for directories.
  #def directories(&block = nil)
    #@directories = DirectoryStructure.new(&block) if block
    #@directories
  #end

  #def files
    ##scaffolding for files, including being able to build licenses
    ##allows for 'directory' call, to create an anonymous (untracked) subdir.
    ##maybe this should go w/ the directories thing.
  #end

  #def package(p)
    ##creates an external dependency, optionally has a ruby block which defines a
    ##script for resolving that dependency
  #end

  #def discover_lib_dependencies!
    ##walks the src_dir tree, parses #includes, finds dependencies (internal and
    ##external
  #end

  #class CompilerDependency

  #end

  #class Dependency
    #include Rake::DSL

    #def resolve!
      #return @status if @status
      #sh "pkg-config #{@name}", verbose: false do |ok, _|
        #if @status = ok
          #"found package #{@name}"
        #else
          #"cannot find package #{@name}"
        #end.tap { |p| puts p }
      #end
    #end
  #end

  #def install_rake_tasks!
    ##creates clean, distclean, build, test, acquire and configure tasks
    ##'acquire' resolves dependencies, maybe name this 'dependencies:all' and
    ##have 1 rake task per dep.
    ##configure should dump a configure.h header with all the normal HAVE_<x>
    ##headers. (maybe only generate those that are needed by inspection?)
    ##
    ##should also make a 'scaffold' task, which builds in all the directory
    ##structures specified by the spec.
    ##
    ##also need a :install task which respects --prefix
  #end

  #def create_compilation_tasks!
    #directories.src
    
  #end
#end

#def project(&block)
  #project = Project.new(&block)
  #project.install_rake_tasks!
end
