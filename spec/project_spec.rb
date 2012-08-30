require 'spec_helper'

describe Project do
  let (:root) { './spec/fake_project/' } 
  let (:project) { Project.new(root) } 

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
    let (:dirs) { [ 'test', 'src', 'obj', 'bin' ] }

    it { should =~ dirs } 
  end

  describe '#files' do 
    subject { project.files } 
    let (:files) { [ 'config.yml', 'Rakefile', 'AUTHORS'] } 

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
