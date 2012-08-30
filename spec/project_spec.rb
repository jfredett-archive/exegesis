require 'spec_helper'

describe Project do
  it { should respond_to :root }
  it { should respond_to :directories } 
  it { should respond_to :files } 

  describe 'creating a project' do end

  describe '#root' do end
  describe '#directories' do end
  describe '#files' do end

  #it should also provide interface for
  #  * creating files/directories
  #    - something like `directories << Directory('foo')` ?
  #
  #it should also have a #visit method, see the NOTES doc for details on that
end
