require 'integration_spec_helper'

# TODO: Promote this into an integration spec, just test API level stuff here.
describe Exegesis::Configuration do
  let(:project_directory) { Exegesis::BaseDirectory.new('./spec/fake_project') }

  subject { Exegesis::Configuration.new(project_directory) }
  it { should be_valid } #validations on the 'AST'
end

