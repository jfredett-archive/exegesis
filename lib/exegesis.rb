require 'rake'
require 'rake/ext/string'

require 'exegesis/version'

require 'exegesis/flyweight'
require 'exegesis/file_searcher'
require 'exegesis/directory'
require 'exegesis/project'
require 'exegesis/source_file'

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

