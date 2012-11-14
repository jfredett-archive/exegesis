require 'unit_spec_helper'

# The tests for this stuff is not the greatest in the world, but the
# transformations it does are relatively dumb, so I'm relying on
# proof-by-inspection a bit. It's unfortunate, but there's really only
# one way to build the internal DSL, and no good way to make assertions
# around how it's parsing stuff.
#
# NOTE: one option would to lazily parse each component, that gives
# a chance to make explicit the 'run' phase, so that message assertions
# at least can make it in.
#
# NOTE: Another option is to have parsing emit events to another object
# which can allow us to monitor them. We can then use that to look at a
# sort of 'live trace' of each event, and make assertions about what's
# happening. Eg.
#
#     project name:foo
#       structure
#         file location:baz type:markdown
#         dir location:bar type:src
#       dependencies:parse
#         compiler name:clang options:'-Wall -Werror' supports:[.c, .cpp]
#       structure:merge
#         file location:README type:plain
#         dir location:foo type:plain
#           file:nested location:foo type:markdown 
#       products:parse
#         #.. snip
#
# This event trace would not be indented as above, but flat, however, each
# trace would be predicticable and deterministic, so we could use it as
# a way to ensure the parse went as expected.

shared_examples_for 'an ast node' do
  describe 'AST Node API' do
    it { should respond_to :visit }
    it { should respond_to :children }
    it { should respond_to :run }
    it { should respond_to :each }

    its(:class) { should respond_to :child_node }
    its(:children) { should respond_to :[] }
    its(:children) { should respond_to :[]= }
    its(:children) { should respond_to :has_key? }

  end
end

describe AST::Project do
  subject do
    project('foo') do
    end
  end

  it_behaves_like 'an ast node'

  describe 'api' do
    it { should respond_to :name }

    it { should respond_to :structure    }
    it { should respond_to :products     }
    it { should respond_to :dependencies }

    its(:structure)    { should be_a_kind_of AST::Structure    }
    its(:products)     { should be_a_kind_of AST::Products     }
    its(:dependencies) { should be_a_kind_of AST::Dependencies }
  end

  describe '#structure' do
    it 'parses structure calls' do
      expect {
        project 'foo' do
          structure do
          end
        end
      }.to_not raise_error
    end

    it 'parses overspecified structure calls' do
      expect {
        project 'foo' do
          structure do
          end

          structure do
          end
        end
      }.to_not raise_error
    end
  end

  describe '#products' do
    it 'parses #products calls' do
      expect {
        project 'foo' do
          products do
          end
        end
      }.to_not raise_error
    end

    it 'parses overspecified products calls' do
      expect {
        project 'foo' do
          products do
          end

          products do
          end
        end
      }.to_not raise_error
    end
  end

  describe '#dependencies' do
    it 'parses #dependencies calls' do
      expect {
        project 'foo' do
          dependencies do
          end
        end
      }.to_not raise_error
    end

    it 'parses overspecified dependencies calls' do
      expect {
        project 'foo' do
          dependencies do
          end

          dependencies do
          end
        end
      }.to_not raise_error
    end
  end
end

