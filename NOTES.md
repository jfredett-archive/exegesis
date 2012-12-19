# Basic structure

## Implementation

* SourceFiles and Directories should be members of a Flyweight, and creation
  should try to do a lookup first. Perhaps Celluloid can be used to do this,
  with directories potentially acting as supervisors.

## Architecture

A suite of raketasks (potentially hidden behind a 'exegesis' script. Adhereing
to the following model:

    class Project
      HAS_MANY BaseDirectories #as a series of methods in a subclass
      HAS_MANY SourceFiles

    Responsibilities:
      this represents the root directory of a project. It will be subclassed
      into project-style specific class. Eg, a RailsProject IS_A Project, it's
      BaseDirectories are, perhaps, `spec`, `app`, `lib`, and `config`. A
      GemProject might have `lib`, `spec`, and `bin`, a C project might have
      `test`, `src`, `vendor`, `obj`, etc.

      It also provides methods like `#build_skeleton!(dir)` which take a
      location in the filesystem and build the structure specified by the
      project.

      It also serves as a point from which we may start a `#visit` to all of
      it's subdirs and files.

    NB:
      It might be interesting to have Projects be able to embed other projects.
      This could be useful for representing, eg, tests in a C project as a
      subproject with it's own file-structure and stuff. So that a CProject is
      now a pair of two underlying `CSourceProject`, each of which has a `src`,
      `obj`, and `vendor`, which in the one project represents the testing
      setup, and the other represents the application setup. Possible problem
      might be trying to get dependencies to work across projects.

    ----------------------------------------------------------------------------

    class BaseDirectory IS_A Directory
      HAS_A Root
      HAS_MANY Directories
      HAS_MANY SourceFiles

    Responsibilities:
      Expose properties of the root directory, Spawn the initial set of
      directories which will recursively find all the files in the project

      The class will also wrap some of the SourceFile classmacros, like #join and
      #expand_path and stuff. Think along the lines of Rails.root and the like.

    Collaborators:
      Directory
      SourceFile

    ----------------------------------------------------------------------------

    class Directory
      HAS_MANY SourceFiles
      HAS_MANY Directories (Children)
      HAS_A Directory (Parent)

    Responsibilities:
      Finds all the files and directories at a given level of the project
      structure, allows for recursive informing of children -- ideally in
      parallel. 

    Collaborators: 
      SourceFile
      Directory

    ----------------------------------------------------------------------------

    class SourceFile
      HAS_A Extension
      HAS_A Path
      HAS_A Base Name
      HAS_MANY SourceFiles (Dependencies)

    Responsibilities:
      Represents a sourcefile on disk, providing access to it's file-system
      related information as well as internal information based on the language.

    Notes:
      This will likely work w/ an inheritance heirarchy for each programming
      language. Mostly it will be one-level deep, but in the case where a
      subsequent language forms a superset/subset, deeper inheritance may occur
      (similarly we might have a module for shared subsets, etc).

    Collaborators:
      SourceFile
      SourceFileFactory       -- to build the appropriate subclass based on file extenstion

    ----------------------------------------------------------------------------

    class SourceFileFactory
      #snip

    Responsibilities:
      Provide an extensible way to build SourceFile instances appropriate to the
      language the source of a given file is in.

    Collaborators:
      LanguageIdentifier
      SourceFile

    ----------------------------------------------------------------------------

    class LanguageIdentifier
      #snip

    Responsibilities:
      A command object to identify the language of a given sourcefile

    Collaborators:
      SourceFileFactory

    ----------------------------------------------------------------------------

    class FileSearcher

    Responsibilities:
      Encapsulates an API for looking through a single directory of files,
      sorting them into directories/files/whatever, and providing those path
      lists on demand

    NB:
      The aim is to isolate the minimum API with this class, so that alternative
      source backends could potentially be written, eg -- a backend for
      distributed sourcetrees, or w/ files in Riak or S3 or whereever

    Collaborators:
      Used By:
        Project, Directory
      Uses:
        Some system-level class like Dir, FileList, or Find


# Tools

Would be nice to model these guys as actors, especially so that we and make use
of that nice async stuff for a little map-reduce-y action. Celluloid? (DCell? :])

# #visit

This is an interface which would take some kind of Visitor class, which defines
up to `n` methods (on for each model type). This method would iterate over all
of it's contents (directories/files/whatever) and apply to each the appropriate
method from the visitor, with the instance as an argument. The visitor can
potentially recursively call #visit on directories, which should also support
this interface

# DSL

w/ the restructure to use the `Project->[BaseDirs]` change, it would be useful to
have a DSL to specify a project in a simpler way than manually defining a new
subclass of `Project`. To wit, I rather like:

    project 'rails' do
      src_dir 'app'
      src_dir 'lib'
      src_dir 'db'

      test_dir 'spec'
      test_dir 'features'

      config_dir 'config'

      file 'Gemfile'
      file 'Rakefile'

      #etc
    end

This would define an appropriate `Project` subclass, called 'RailsProject', with methods pointing to
the various subdirs.

# Features

## Core Features (Must Haves)

* Automatic Building w/ dependency discovery
  - manual configuration of dependencies also allowed
  - parallel builds by default
* Automatic Test Suite w/ boilerplate autogenerated
  - Integrates with specific tools to do this, eg, Check or CUnit, etc.
* Handles at least C, C++, and maybe Go and Rust

## Added Features (Should Haves)

* Automatic, file-system-event based recompiles.
* Integration with other Unit testing systems

## Neat Features (Could Haves)

* Statistics on code base (LOC, Complexity metrics, etc)
* Plugin API

## Far out Features (Want-to Haves)

* Language-aware search indexing (with ElasticSearch backend?)

## Random features

* Automatically generate git helper stuff
  - spawn a repo
  - build the project skeleton
  - set up gitignore
  - set up hooks (run tests, etc)
  - Set up standard docs (README, AUTHORS, LICENSE, etc)

# Notes on how projects should work

* Project is the thing that interfaces with rake.
  - creating a project creates a series of directory tasks, provides the
    exegesis DSL for specifying package deps/whatever in whatever language
  - it should automatically generate `clean`, `distclean`, and `scaffold`
    tasks, the last of which is just a task that depends on all the directory
    tasks
  - it should use the environment for configuration.

* The Project should also automatically generate a default task which builds all
  the binaries, tasks which build each binary individually, and a `install` task
  which copies it to the appropriate place on the PATH

* The Project should, in particular, support multi-threaded compilation.


