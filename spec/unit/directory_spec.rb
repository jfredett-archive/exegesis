require 'unit_spec_helper'

describe Directory do
  let (:parent)      { double('parent directory')               }
  let (:parent_path) { 'parent/'                                }
  let (:name)        { 'subdir/'                                }
  let (:searcher)    { double('searcher')                       }
  let (:directory)   { Directory.create(parent, name, searcher) }

  before do
    parent.stub(:is_a?).with(Directory).and_return(true)
    parent.stub(:path).and_return(parent_path)

    searcher.stub(:new).and_return(searcher)
  end

  subject { directory }

  it_should_behave_like 'a FileSystemEntity'

  describe 'api' do
    it { should respond_to :directories    }
    it { should respond_to :parent         }
    it { should respond_to :files          }
    it { should respond_to :path           }
    it { should respond_to :children       }
    it { should respond_to :find_file      }
    it { should respond_to :find_directory }

    its(:class) { should respond_to :create }
  end

  it { should delegate(:files).to(searcher) }
  it { should delegate(:directories).to(searcher) }

  describe '#path' do
    subject { directory.path }

    it { should be_a String }
    it { should == File.join(parent_path, name) }
  end

  describe '#find_file' do
    let(:file_foo) { double("sourcefile('foo')", name: 'foo') }
    let(:file_bar) { double("sourcefile('bar')", name: 'bar') }
    let(:files) { [file_foo, file_bar] }

    before { directory.stub(:files).and_return files }

    subject { directory.find_file('foo') }

    it { should be file_foo }
  end

  describe '#find_directory' do
    let(:directory_foo) { double("directory('foo')", name: 'foo') }
    let(:directory_bar) { double("directory('bar')", name: 'bar') }
    let(:directories) { [directory_foo, directory_bar] }

    before { directory.stub(:directories).and_return directories }

    subject { directory.find_directory('foo') }

    it { should be directory_foo }
  end

end
