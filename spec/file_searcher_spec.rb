require 'spec_helper'

describe FileSearcher do
  let (:root) { double('a fake backend') }
  let (:globbed_path) { double('a fake glob of root with *') } 
  let (:file_searcher) { FileSearcher.new(root) }
  let (:dir) { double('a fake directory') } 
  let (:file) { double('a fake file') }

  before do
    File.stub(:directory?).with(dir).and_return(true)
    File.stub(:directory?).with(file).and_return(false)
    File.stub(:file?).with(file).and_return(true)
    File.stub(:file?).with(dir).and_return(false)
    File.stub(:join).and_return(globbed_path)
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
      subject { file_searcher.directories } 

      it { should contain(dir) }
      it { should exclude(file) }
    end

    describe '#files' do
      subject { file_searcher.files } 

      it { should contain(file) }
      it { should exclude(dir) }
    end
  end
end
