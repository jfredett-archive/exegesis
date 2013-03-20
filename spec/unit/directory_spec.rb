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
    it { should respond_to :directories }
    it { should respond_to :parent      }
    it { should respond_to :files       }
    it { should respond_to :path        }
    it { should respond_to :children    }
    it { should respond_to :[]          }

    its(:class) { should respond_to :create }
  end

  it { should delegate(:files).to(searcher) }
  it { should delegate(:directories).to(searcher) }

  describe '#path' do
    subject { directory.path }

    it { should be_a String }
    it { should == File.join(parent_path, name) }
  end
end
