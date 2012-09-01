require 'spec_helper'

describe SourceFile do
  let(:basename)  { 'fake'               }
  let(:extension) { '.c'                 }
  let(:name)      { basename + extension }
  let(:parent)    { double('directory')  }

  let(:full_path) { File.join(parent.path, name) }
  let(:content)   { double('content')            }

  let(:source_file) { SourceFile.new(parent, name) } 

  subject { source_file } 

  before do 
    parent.stub(:path).and_return('/path/to/parent/')
    parent.stub(:is_a?).with(Directory).and_return(true)
    File.stub(:read).with(full_path).and_return(content) 
  end

  describe 'api' do
    it { should respond_to :extension }
    it { should respond_to :ext       }

    it { should respond_to :basename }
    it { should respond_to :name     }

    it { should respond_to :path      }
    it { should respond_to :content   }

    it { should respond_to :parent    }
    it { should respond_to :container }

    pending 'dependencies' do
      it { should respond_to :dependencies } 
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

    it 'raises an error if you try to give a parent that is not a Directory' do
      expect { SourceFile.new(:not_a_dir, name) }.to raise_error ArgumentError
    end
    it { should == source_file.container } 
  end

  describe '#content' do
    before { source_file.content } 

    the_class(File) { should have_received(:read).with(full_path) } 
  end
end
