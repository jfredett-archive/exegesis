require 'unit_spec_helper'

describe Exegesis::AST::Src do
  it_behaves_like 'an ast node'
  it_behaves_like 'a terminal node'
end
