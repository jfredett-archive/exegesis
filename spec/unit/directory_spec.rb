require 'unit_spec_helper'

describe Directory do
  let (:parent)      { double('parent directory')            }
  let (:parent_path) { 'parent/'                             }
  let (:name)        { 'subdir/'                             }
  let (:searcher)    { double('searcher')                    }
  let (:directory)   { Directory.new(parent, name, searcher) }

  before do
    parent.stub(:is_a?).with(Directory).and_return(true)
    parent.stub(:path).and_return(parent_path)

    searcher.stub(:new).and_return(searcher)
  end

  describe 'initialization' do
    before {
      searcher.stub!(:new)
      Directory.new(parent, name, searcher)
    }

    the(:searcher) { should have_received(:new).with(File.join(parent_path, name)) }
  end

  subject { directory }

  describe 'api' do
    it { should respond_to :directories }
    it { should respond_to :parent      }
    it { should respond_to :files       }
    it { should respond_to :path        }
    it { should respond_to :children    }

    its(:class) { should respond_to :create }
  end

  it { should delegate(:files).to(searcher) }
  it { should delegate(:directories).to(searcher) }

  describe '#path' do
    subject { directory.path }

    it { should be_a String }
    it { should == File.join(parent_path, name) }
  end


  shared_examples_for 'a flyweight object' do
    # this is a gross way to create enough mocked arguments to appropriately
    # fufill the requirements for the create method for whatever object we have.
    #let (:mock_arguments) { ([proc { mock('argument').as_null_object } ] * subject.method(:create).arity).map &:call }

  end
  # deleting a directory should delete it's subdirectories
  # deleting a directory should delete it's instance from the flyweight
  # creating a directory that does not exist on the system should mkdir the
  #   directory.
  # #create should be aliased to #mkdir
  # #[] should look up by full path, using create and the default filesearcher
  #   (ie, it parses out parent and name)


  #context do
    #subject { Directory }
    #it_behaves_like 'a flyweight object'
  #end

  #integration spec between Directory and Flyweights
  context 'flyweightyness' do
    describe 'creating an object' do
      let!(:first_instance) { Directory.create(parent, name) }
      subject { Directory.create(parent, name) }

      it { should == first_instance }
    end

    describe 'deleting an object' do

    end

    describe 'retrieving an object' do

    end
  end
end
