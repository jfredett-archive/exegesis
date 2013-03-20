require 'unit_spec_helper'

describe Exegesis::FileSearcher do
  let (:root)          { double('a fake backend')                      }
  let (:root_path)     { double('a fake path')                         }
  let (:globbed_path)  { double('a fake glob of root_path with *')     }
  let (:fs_interface)  { double('a File System Interface like `File`') }
  let (:file_searcher) { Exegesis::FileSearcher.new(root, fs_interface)          }
  let (:dir)           { double('a fake directory')                    }
  let (:file)          { double('a fake file')                         }
  let (:file_path)     { double('the fake file path')                  }
  let (:dir_path)      { double('the directory file path')             }

  let (:fake_source_file_instance) { double('a fake SourceFile instance') }
  let (:fake_directory_instance)   { double('a fake Directory instance')  }

  before do
    fs_interface.stub(:directory?).with(dir).and_return(true)
    fs_interface.stub(:file?).with(dir).and_return(false)
    fs_interface.stub(:basename).with(dir).and_return(dir)

    fs_interface.stub(:directory?).with(file).and_return(false)
    fs_interface.stub(:file?).with(file).and_return(true)
    fs_interface.stub(:basename).with(file).and_return(file)

    fs_interface.stub(:join).with(root_path, '*').and_return(globbed_path)
    fs_interface.stub(:join).with(root_path, file).and_return(file_path)
    fs_interface.stub(:join).with(root_path, dir).and_return(dir_path)

    Exegesis::Directory.stub(:new).with(root, dir).and_return(fake_directory_instance)
    Exegesis::SourceFile.stub(:new).with(root, file).and_return(fake_source_file_instance)

    fake_source_file_instance.stub(:is_a?).with(Exegesis::SourceFile).and_return(true)
    fake_directory_instance.stub(:is_a?).with(Exegesis::Directory).and_return(true)

    root.stub(:path).and_return(root_path)
  end

  subject { file_searcher }

  describe 'api' do
    it { should respond_to :directories }
    it { should respond_to :files }
    it { should respond_to :content }
  end

  pending "better dependency injection" do
    describe '#content' do
      before do
        Dir.stub(:[])
        file_searcher.content
      end

      the(Dir) { should have_received(:[]).with(globbed_path) }
    end
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

      the_class(Exegesis::Directory) { should have_received(:new).with(root, dir) }
      the_class(Exegesis::SourceFile) { should_not have_received(:new) }
    end

    describe '#files' do
      let! (:files) { file_searcher.files }
      subject { files }

      it { should contain(fake_source_file_instance) }
      it { should exclude(fake_directory_instance)   }

      the_class(Exegesis::Directory) { should_not have_received(:new) }
      the_class(Exegesis::SourceFile) { should have_received(:new).with(root, file) }
    end
  end
end
