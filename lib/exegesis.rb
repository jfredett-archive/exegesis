
################################################################################
#load order matters here. These are sorted into load-levels Level-0 files must
#be loaded before Level-1's, etc. try to keep this sorted. any file after the
#line is 'load-whenever'
################################################################################

#Level 0
require 'rake'
require 'rake/ext/string'
require 'forwardable'

#Level 1
require 'exegesis/flyweight'

#Level 2
require 'exegesis/registerable'

#Level 3
require 'exegesis/file_system_entity'
require 'exegesis/file_searcher'

#Level 4
require 'exegesis/directory'
require 'exegesis/source_file'

#Level 5
require 'exegesis/base_directory'
require 'exegesis/ast'

#Level 6
require 'exegesis/configuration'

#-------------------------------------------------------------------------------
#load whenever
require 'exegesis/version'

################################################################################


# Exegesis is a tool for automating many parts of the development of C projects.
# Following a convention-over-configuration model.
#
# It provides tools to:
#
#   * Create skeleton projects
#   * Build
#   * Testing
#   * Packaging
#
# Though C is presently the only supported language, it is the aim of Exegesis to
# support tooling for other compiled languages.
module Exegesis; end

# The top level method to define a configuration
def project(name = nil, opts={}, &block)
  Exegesis::AST::Project.new(name, opts.merge({parent: nil}), &block)
end
