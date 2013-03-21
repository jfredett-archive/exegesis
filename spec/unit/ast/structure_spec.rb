require 'unit_spec_helper'

describe Exegesis::AST::Structure do
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
