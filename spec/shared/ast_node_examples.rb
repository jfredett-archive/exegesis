shared_examples_for 'an ast node' do
  describe 'AST Node API' do
    it { should respond_to :visit    }
    it { should respond_to :children }
    it { should respond_to :run      }
    it { should respond_to :each     }

    its(:class) { should respond_to :terminal    }
    its(:class) { should respond_to :terminal?   }
    its(:class) { should respond_to :multiple    }
    its(:class) { should respond_to :nonterminal }
    its(:class) { should respond_to :terminal!   }
    its(:class) { should respond_to :name        }

    its(:children) { should respond_to :[]       }
    its(:children) { should respond_to :[]=      }
    its(:children) { should respond_to :has_key? }
  end
end
