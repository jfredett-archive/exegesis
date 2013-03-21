shared_examples_for 'a nonterminal node' do
  its(:class) { should_not be_terminal }
end
