describe Exegesis::AST::Validator do
  context 'invalid ASTs' do
    describe 'project node validations' do
      subject(:validator) { Exegesis::AST::Validator.new }
      before { ast.visit(validator) }

      context 'name is nil' do
        let(:ast) { project { } }

        it { should be_invalid }
        its(:errors) { should have_key :project }
      end

      context 'valid project definition' do
        let(:ast) { project('project') { } }

        it { should be_valid }
        its(:errors) { should be_empty }
      end
    end
  end
end
