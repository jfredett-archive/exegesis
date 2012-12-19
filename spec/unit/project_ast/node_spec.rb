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
#         dir:nest location:foo type:plain
#           file location:foo type:markdown
#         dir:unnest
#       products:parse
#         #.. snip
#
# This event trace would not be indented as above, but flat, however, each
# trace would be predicticable and deterministic, so we could use it as
# a way to ensure the parse went as expected.
#
# TODO: Better Tests
# TODO: Break up files
# TODO: Get Rid of hash crap... everything should be an object, just deal with
#       it.

shared_examples_for 'an ast node' do
  describe 'AST Node API' do
    it { should respond_to :visit    }
    it { should respond_to :children }
    it { should respond_to :run      }
    it { should respond_to :each     }

    its(:class) { should respond_to :terminal    }
    its(:class) { should respond_to :terminal?   }
    its(:class) { should respond_to :multiple    }
    its(:class) { should respond_to :nonterminal }
    its(:class) { should respond_to :terminal!   }
    its(:class) { should respond_to :name        }

    its(:children) { should respond_to :[]       }
    its(:children) { should respond_to :[]=      }
    its(:children) { should respond_to :has_key? }
  end
end

shared_examples_for 'a terminal node' do
  its(:class) { should be_terminal }
end

shared_examples_for 'a nonterminal node' do
  its(:class) { should_not be_terminal }
end

describe AST::Project do
  subject do
    AST::project('foo') do
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
        AST::project 'foo' do
          structure do
          end
        end
      }.to_not raise_error
    end

    it 'parses overspecified structure calls' do
      expect {
        AST::project 'foo' do
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
        AST::project 'foo' do
          products do
          end
        end
      }.to_not raise_error
    end

    it 'parses overspecified products calls' do
      expect {
        AST::project 'foo' do
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
        AST::project 'foo' do
          dependencies do
          end
        end
      }.to_not raise_error
    end

    it 'parses overspecified dependencies calls' do
      expect {
        AST::project 'foo' do
          dependencies do
          end

          dependencies do
          end
        end
      }.to_not raise_error
    end
  end
end

describe AST::Structure do
  it_behaves_like 'an ast node'

  it 'parses structure calls' do
    expect {
      structure do
        #special directory names -- no scaffolded subdirs allowed
        src  'src/'
        obj  'obj/'
        test 'test/'
        bin  'bin/'
        #vendor 'external/'

        file 'README', type: :markdown

        #bare files
        file 'AUTHORS'
        file 'CHANGELOG'

        #autogenerate a license of choice
        license 'BSD3'

        directory 'doc/' do
          #arbitrary directory, everything below gets prefixed
          file 'manpage'
        end
      end
    }
  end
end

describe AST::SourceFile do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'
  its('class.name') { should == 'File' }
end
describe AST::Products do
  it_behaves_like 'an ast node'
  it_behaves_like 'a nonterminal node'
end

describe AST::Dependencies do
  it_behaves_like 'an ast node'
  it_behaves_like 'a nonterminal node'
end

describe AST::Directory do
  it_behaves_like 'an ast node'
  it_behaves_like 'a nonterminal node'
end

describe AST::Binary do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'
end

describe AST::Lib do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'
end

describe AST::Compiler do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'
end

describe AST::Package do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'
end

describe AST::Src do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'
end

describe AST::Obj do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'
end

describe AST::Bin do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'
end

describe AST::Test do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'
end

describe AST::License do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'
end

describe AST::Deps do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'

  its('class.name') { should == 'Dependencies' }
end
