module Exegesis; end

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

#-------------------------------------------------------------------------------
#load whenever
require 'exegesis/version'
