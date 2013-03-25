shared_examples_for 'a FileSystemEntity' do
  describe 'api' do
    it { should respond_to :path      }
    it { should respond_to :basename  }
    it { should respond_to :visit     }

    it { should respond_to :parent    }
    it { should respond_to :container } #alias

    it { should respond_to :name }

    it { should respond_to :ext       }
    it { should respond_to :extension } #alias
  end
end
