require 'unit_spec_helper'

describe Exegesis::BaseDirectory do
  let (:root)     { double('some path to a project directory').as_null_object }
  let (:searcher) { double('directory searcher like FileSearcher') }
  let (:dir)      { double('fake directory') }
  let (:file)     { double('fake file') }

  let (:project) { Exegesis::BaseDirectory.create(root, searcher) }

  before do
    searcher.stub(:[]).with(root + '*').and_return([dir, file])
    searcher.stub(:new).and_return(searcher)
    searcher.stub(:search).and_return(searcher)
  end

  subject { project }

  it_should_behave_like 'a FileSystemEntity'

  describe 'api' do
    it { should be_a Exegesis::Directory }
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
