require 'spec_helper'

describe Project do
  let (:root) { double('some path to a project directory').as_null_object } 
  let (:searcher) { double('directory searcher like Dir') } 
  let (:dir) { double('fake directory') }
  let (:file) { double('fake file') }

  let (:project) { Project.new(root, searcher) } 


  before do
    searcher.stub(:[]).with(root + '*').and_return([dir, file])

    File.stub(:directory?).with(dir).and_return(true)
    File.stub(:directory?).with(file).and_return(false)

    File.stub(:basename).with(dir).and_return(dir)
    File.stub(:basename).with(file).and_return(file)
  end

  subject { project } 

  describe 'api' do
    it { should respond_to :root }
    it { should respond_to :directories } 
    it { should respond_to :files } 
  end

  describe '#root' do
    subject { project.root } 

    it { should == root }
  end

  describe '#directories' do
    subject { project.directories } 

    let (:dirs) { [ dir ] }

    it { should =~ dirs } 
  end

  describe '#files' do 
    subject { project.files } 

    let (:files) { [ file ] } 

    it { should =~ files } 
  end

  #it should also provide interface for
  #  * creating files/directories
  #    - something like `directories << Directory('foo')` ?
  #
  #  * 
  #
  #it should also have a #visit method, see the NOTES doc for details on that
end
