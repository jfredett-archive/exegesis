module Exegesis
  module AST
    def self.project(name = nil, opts={}, &block)
      Exegesis::AST::Project.new(name, opts.merge({parent: nil}), &block)
    end
  end
end

require 'exegesis/ast/object_set'
require 'exegesis/ast/node'

require 'exegesis/ast/bin'
require 'exegesis/ast/src'
require 'exegesis/ast/obj'
require 'exegesis/ast/test'
require 'exegesis/ast/deps'

require 'exegesis/ast/lib'
require 'exegesis/ast/binary'
require 'exegesis/ast/compiler'
require 'exegesis/ast/source_file'

require 'exegesis/ast/directory'
require 'exegesis/ast/license'
require 'exegesis/ast/package'

require 'exegesis/ast/dependencies'
require 'exegesis/ast/structure'
require 'exegesis/ast/products'

require 'exegesis/ast/project'

require 'exegesis/ast/visitor'

require 'exegesis/ast/validator'
