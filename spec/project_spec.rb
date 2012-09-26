require 'spec_helper'

describe Project do
  let (:root)     { double('some path to a project directory').as_null_object }
  let (:searcher) { double('directory searcher like FileSearcher') }
  let (:dir)      { double('fake directory') }
  let (:file)     { double('fake file') }

  let (:project) { Project.new(root, searcher) }


  before do
    searcher.stub(:[]).with(root + '*').and_return([dir, file])
    searcher.stub(:new).and_return(searcher)
    searcher.stub(:search).and_return(searcher)
  end

  describe 'initialization' do
    before {
      searcher.stub!(:new)
      Project.new(root, searcher)
    }

    the(:searcher) { should have_received(:new).with(project) }
  end


  context do
    subject { project }

    describe 'api' do
      it { should be_a Directory }
      it { should respond_to :root }
      it { should respond_to :directories }
      it { should respond_to :files }
    end

    describe '#root' do
      subject { project.root }
      it { should == root }
    end

    it { should delegate(:files).to(searcher) }
    it { should delegate(:directories).to(searcher) }

    #it should also provide interface for
    #  * creating files/directories
    #    - something like `directories << Directory('foo')` ?
    #
    #  *
    #
    #it should also have a #visit method, see the NOTES doc for details on that
  end
end
