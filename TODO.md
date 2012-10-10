1. Projects
  1.1. Composite projects

2. Dependency Heirarchy (#visit should respect it)
  2.1. Explicit-ordering
      That is, an explicit sort based on a list of key/list pairs, the key being
      the object that depends on the others being processed. We should have a
      generic visitor class that can consume such a list and respect that
      dependency structure when doing it's visitation.

  2.2. Driven by a real example
      Write a nontrivial (but simple) app in C/Go/Typescript/whatever, try to
      use Exegesis to do dependency discovery, set up rake-tasks for
      compilation, etc.

3. FileUtil methods
  3.1 Directories should respond to stuff like `#mkdir`, `#ls`, etc. we should
  have `#cd` return a BaseDirectory for the given path, perhaps. SourceFiles
  should respond to `#stat`, etc. Basically load up the filesystem as methods.

4. Break up FileSystemEntity into several modules
  it's a bit of a hodge-podge at the moment

5. Search
  Need to be able to search for files in-project and on-path (the latter being
  for referencing system-librarys). Exegesis, in the long run, is going to
  calculate at least the following tasks:

    * <rake task> ~ <equivalent make-related task>

    * configure   ~ ./configure
    * default     ~ make
    * all         ~ make all
    * install     ~ make install
    * clean       ~ make clean
    * distclean   ~ make distclean

  In particular, configure needs to be able to calculate external dependencies
  and use pkg-config to check for them (in the cases where pkg-config makes
  sense). Ideally with minimal effort it could automatially scour something like
  CPAN for C projects (CCAN?) or w/e and find where you have to go to install
  those dependencies.

  In any case, we need the ability to reference files in-context, so that an
  `#include 'foo/bar'` in the src directory knows to reference `src/foo/bar`
  and not `obj/foo/bar` in it's dependency setup. It would be good to also
  implement `find` in terms of exegesis.

6. Celluloid
  It would be very powerful to be able to have each file act independently,
  especially in the case of `#visit`, because we can asynchronously spawn
  visitors to do their work, and as long as the visitor can manage concurrent
  access, the directories/files it visits have no shared state with anything,
  and thus should be pretty easy to fit into a multi-threaded, link-free
  framework like exegesis.

------ Things worth doing later ------

1. Model symlinks
2. build a visitor that outputs a `dot` graph of the folder heirarchy. bonus
   points for outputting a DAG when symlinks are built
3. Performance testing.

