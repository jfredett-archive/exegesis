require 'unit_spec_helper'

describe SourceFile do
  let(:basename)     { 'fake'               }
  let(:extension)    { '.c'                 }
  let(:name)         { basename + extension }
  let(:parent)       { double('directory')  }
  let(:fs_interface) { double('an arbitrary interface to a filesystem') }

  # TODO: Eliminate use of File here? More mocks?
  let(:full_path) { File.join(parent.path, name) }
  let(:content)   { double('content')            }

  let(:source_file) { SourceFile.create(parent, name, fs_interface) }


  subject { source_file }

  before do
    parent.stub(:path).and_return('/path/to/parent/')
    parent.stub(:is_a?).with(Directory).and_return(true)

    fs_interface.stub(:read).with(full_path).and_return(content)
    fs_interface.stub(:extname).with(name).and_return(extension)
  end

  describe 'instantiation' do
    it 'disallows instantiation via #new' do
      expect { SourceFile.new(parent, name) }.to raise_error NoMethodError
    end
  end

  describe 'api' do
    context 'basic interface' do
      it { should respond_to :extension }
      it { should respond_to :ext       }

      it { should respond_to :basename }
      it { should respond_to :name     }

      it { should respond_to :path      }
      it { should respond_to :content   }

      it { should respond_to :parent    }
      it { should respond_to :container }
    end

    context 'dependencies' do
      it { should respond_to :dependencies }
      it { should respond_to :depends_on }
    end

    pending 'language identification' do
      it { should respond_to :language }
      it { should respond_to :language? }
    end
  end

  describe '#path' do
    subject { source_file.path }

    it { should == full_path }
  end

  describe '#extension' do
    subject { source_file.extension }

    it { should == subject.ext }
    it { should == extension }
  end

  describe '#basename' do
    subject { source_file.basename }

    it { should == basename }
  end

  describe '#name' do
    subject { source_file.name }

    it { should == name }
    it { should == source_file.basename + source_file.ext }
  end

  describe '#parent' do
    subject { source_file.parent }

    pending 'reimplementation' do
      it 'raises an error if you try to give a parent that is not a Directory' do
        expect { SourceFile.create(:not_a_dir, name) }.to raise_error ArgumentError
      end
    end
    it { should == source_file.container }
  end

  describe '#content' do
    before { source_file.content }

    the(:fs_interface) { should have_received(:read).with(full_path) }
  end

  describe '#dependencies' do
    let(:file) { double('another sourcefile') }
    let(:not_a_file) { double('not a sourcefile') }

    before { file.stub(:is_a?).with(SourceFile).and_return(:true) }

    subject { source_file.dependencies }

    it { should respond_to :each }
    it { should be_empty }

    describe '#depends_on' do
      before { source_file.depends_on(file) }

      it { should =~ [file] }

      it 'raises unless the dependency is a file' do
        expect {
          source_file.depends_on(not_a_file)
        }.to raise_error InvalidDependency
      end
    end
  end

  #this should be a shared pattern between directories, sourcefiles, etc.
  describe 'flyweight nature' do
    #it should not create two identical instances
  end

  #deleting a file should delete it's instance from the flyweight
end
