require 'spec_helper'

describe FileSearcher do
  let (:root)                      { double('a fake backend')             }
  let (:globbed_path)              { double('a fake glob of root with *') }
  let (:file_searcher)             { FileSearcher.new(root)               }
  let (:dir)                       { double('a fake directory')           }
  let (:file)                      { double('a fake file')                }

  let (:fake_source_file_instance) { double('a fake SourceFile instance') }
  let (:fake_directory_instance)   { double('a fake Directory instance')  }

  before do
    File.stub(:directory?).with(dir).and_return(true)
    File.stub(:directory?).with(file).and_return(false)
    File.stub(:file?).with(file).and_return(true)
    File.stub(:file?).with(dir).and_return(false)
    File.stub(:join).and_return(globbed_path)

    Directory.stub(:new).with(dir).and_return(fake_directory_instance)
    SourceFile.stub(:new).with(file).and_return(fake_source_file_instance)

    fake_source_file_instance.stub(:is_a?).with(SourceFile).and_return(true)
    fake_directory_instance.stub(:is_a?).with(Directory).and_return(true)
  end

  subject { file_searcher }

  describe 'api' do
    it { should respond_to :directories }
    it { should respond_to :files }
    it { should respond_to :content }
  end

  describe '#content' do
    before do
      Dir.stub(:[])
      file_searcher.content
    end

    the(Dir) { should have_received(:[]).with(globbed_path) }
  end

  context do
    before do
      file_searcher.stub(:content).and_return([dir, file])
    end

    describe '#directories' do
      let! (:directories) { file_searcher.directories }
      subject { directories }

      it { should contain(fake_directory_instance)   }
      it { should exclude(fake_source_file_instance) }

      the_class(Directory) { should have_received(:new).with(dir) }
      the_class(SourceFile) { should_not have_received(:new) }
    end

    describe '#files' do
      let! (:files) { file_searcher.files }
      subject { files }

      it { should contain(fake_source_file_instance) }
      it { should exclude(fake_directory_instance)   }

      the_class(Directory) { should_not have_received(:new) }
      the_class(SourceFile) { should have_received(:new).with(file) }
    end
  end
end
