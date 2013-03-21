require 'unit_spec_helper'

describe Exegesis::AST::Project do
  subject do
    Exegesis::AST::project('foo') do
    end
  end

  it_behaves_like 'an ast node'

  describe 'api' do
    it { should respond_to :name }

    it { should respond_to :structure    }
    it { should respond_to :products     }
    it { should respond_to :dependencies }

    its(:structure)    { should be_a_kind_of Exegesis::AST::Structure    }
    its(:products)     { should be_a_kind_of Exegesis::AST::Products     }
    its(:dependencies) { should be_a_kind_of Exegesis::AST::Dependencies }
  end

  describe '#structure' do
    it 'parses structure calls' do
      expect {
        Exegesis::AST::project 'foo' do
          structure do
          end
        end
      }.to_not raise_error
    end

    it 'parses overspecified structure calls' do
      expect {
        Exegesis::AST::project 'foo' do
          structure do
          end

          structure do
          end
        end
      }.to_not raise_error
    end

    it "does not parse if nested incorrectly" do
      expect { Exegesis::AST::project 'foo' do
        structure do
          structure do
          end
        end
      end }.to raise_error
    end
  end

  describe '#products' do
    it 'parses #products calls' do
      expect {
        Exegesis::AST::project 'foo' do
          products do
          end
        end
      }.to_not raise_error
    end

    it 'parses overspecified products calls' do
      expect {
        Exegesis::AST::project 'foo' do
          products do
          end

          products do
          end
        end
      }.to_not raise_error
    end
  end

  describe '#dependencies' do
    it 'parses #dependencies calls' do
      expect {
        Exegesis::AST::project 'foo' do
          dependencies do
          end
        end
      }.to_not raise_error
    end

    it 'parses overspecified dependencies calls' do
      expect {
        Exegesis::AST::project 'foo' do
          dependencies do
          end

          dependencies do
          end
        end
      }.to_not raise_error
    end
  end
end
