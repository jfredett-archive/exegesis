require 'unit_spec_helper'

describe FileSearcher do
  let (:root)          { double('a fake backend')                  }
  let (:root_path)     { double('a fake path')                     }
  let (:globbed_path)  { double('a fake glob of root_path with *') }
  let (:file_searcher) { FileSearcher.new(root)                    }
  let (:dir)           { double('a fake directory')                }
  let (:file)          { double('a fake file')                     }
  let (:file_path)     { double('the fake file path')              }

  let (:fake_source_file_instance) { double('a fake SourceFile instance') }
  let (:fake_directory_instance)   { double('a fake Directory instance')  }

  before do
    File.stub(:directory?).with(dir).and_return(true)
    File.stub(:file?).with(dir).and_return(false)
    File.stub(:basename).with(dir).and_return(dir)

    File.stub(:directory?).with(file).and_return(false)
    File.stub(:file?).with(file).and_return(true)
    File.stub(:basename).with(file).and_return(file)

    File.stub(:join).with(root_path, '*').and_return(globbed_path)
    File.stub(:join).with(root_path, file).and_return(file_path)

    Directory.stub(:new).with(root, dir).and_return(fake_directory_instance)
    SourceFile.stub(:new).with(root, file).and_return(fake_source_file_instance)

    fake_source_file_instance.stub(:is_a?).with(SourceFile).and_return(true)
    fake_directory_instance.stub(:is_a?).with(Directory).and_return(true)

    root.stub(:path).and_return(root_path)
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

      the_class(Directory) { should have_received(:new).with(root, dir) }
      the_class(SourceFile) { should_not have_received(:new) }
    end

    describe '#files' do
      let! (:files) { file_searcher.files }
      subject { files }

      it { should contain(fake_source_file_instance) }
      it { should exclude(fake_directory_instance)   }

      the_class(Directory) { should_not have_received(:new) }
      the_class(SourceFile) { should have_received(:new).with(root, file) }
    end
  end
end
