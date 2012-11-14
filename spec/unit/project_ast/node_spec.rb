require 'unit_spec_helper'

shared_examples_for 'an ast node' do
  describe 'AST Node API' do
    it { should respond_to :visit }
    it { should respond_to :children }
    its(:children) { should respond_to :each }
  end
end

describe AST::Project do
  subject do
    project('foo') do
    end
  end

  it_behaves_like 'an ast node'

  describe 'api' do
    it { should respond_to :name }

    it { should respond_to :structure    }
    it { should respond_to :products     }
    it { should respond_to :dependencies }
  end

  describe '#structure' do
    it 'parses structure calls' do
      expect {
        project 'foo' do
          structure do
          end
        end
      }.to_not raise_error
  end
  end

  describe '#products' do
    it 'parses #products calls' do
      expect {
        project 'foo' do
          products do
          end
        end
      }.to_not raise_error
    end
  end

  describe '#dependencies' do
    it 'parses #dependencies calls' do
      expect {
        project 'foo' do
          dependencies do
          end
        end
      }.to_not raise_error
    end
  end
end

