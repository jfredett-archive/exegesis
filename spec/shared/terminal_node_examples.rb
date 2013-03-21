shared_examples_for 'a terminal node' do
  its(:class) { should be_terminal }
end
