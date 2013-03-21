require 'unit_spec_helper'

# TODO: Promote this into an integration spec, just test API level stuff here.
describe Exegesis::Project do
  let (:config_content) do
    %{
    AST::project 'fake' do
      structure do
        #special directory names -- no scaffolded subdirs allowed
        src  'src/'
        obj  'obj/'
        test 'test/'
        bin  'bin/'
        #vendor 'external/'

        #add appropriate extension?
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


      products do
        # binary to compile and put in bin/
        binary 'fake_bin' do
          #dependencies, can be built automatically using SRC + visitor, or just
          #SRC for everything.
          dependencies ['foo', 'bar', 'baz']
        end

        # a lib to compile and put in bin/
        lib 'some_lib' do
          dependencies ['quux', 'qlang', 'qfizzle'] #see above in `binary`
        end
      end

      dependencies do
        #compilers are applied in order, so this will match before the compiler
        #below
        compiler name: 'test-preprocessor.rb',
                 supports: ['_test.c', '_test.cpp']

        #specify a compiler dependency
        compiler name:     'clang',         #name of binary
                 options:  '-Wall -Werror', #options to pass it
                 supports: ['.c', '.cpp']   #what filetypes it supports

        #if multiple compilers are specified, then the first is considered the
        #default, and there will be generated a namespace'd version of each
        #compiler, so `rake` will use the default, `rake clang` will use clang
        #(in this case), and `rake gcc` will use GCC. You can still just set
        #CC as an override.
        compiler name:     'gcc',
                 options:  '-Wall -Werror',
                 supports: ['.c', '.cpp']

      compiler name: 'thrift',
                 supports: '.thrift'

        #TODO: Supporting multiple build specifications, perhaps break compiler
        #specs into their own grouping w/ a name-per-target, eg:
        #
        #target :debug do ... end
        #target :release do ... end
        #
        #etc?

        package 'an_external_dependency' do
          #script for getting external dep

          #deps are put in vendor/ or whatever is given in the directories block
        end

        package 'another_external_dep'
          #no script, manual install required, automatic check still provided in
      end
    end
    }
  end

  let(:project_directory) { double("base directory") }

  let(:exegesis_file) { double('exegesis config file', name: 'exegesis', content: config_content) }

  before do
    project_directory.stub("find_file").with('exegesis').and_return(exegesis_file)
  end

  subject { Exegesis::Project.new(project_directory) }

  pending 'reorganizing of spec' do
    its(:config) { should be_valid } #validations on the 'AST'

    #put this in it's own specfile.
    describe 'invalid ASTs' do
      describe 'project node validations' do
        context 'name is nil' do
          let(:project_ast) { Exegesis::AST.project { } }
          subject { Exegesis::AST::Project.new(project_ast) }

          it { should be_invalid }
          its(:errors) { should have_key :project }
        end

        context 'valid project definition' do
          let(:project_ast) { Exegesis::AST.project('project') { } }
          subject { Exegesis::AST::Project.new(project_ast) }

          it { should be_valid }
          its(:errors) { should be_empty }
        end
      end

      describe 'structure node validations' do
      end
    end
  end
end

