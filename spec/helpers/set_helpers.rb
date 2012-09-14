require 'rspec/expectations'

RSpec::Matchers.define :be_a_superset_of do |expected|
  match do |obj|
    expected.should be_a_subset_of obj
  end
end

RSpec::Matchers.define :be_a_subset_of do |expected|
  match do |obj|
    obj.each do |e|
      expected.include?(e)
    end
  end
end

RSpec::Matchers.define :contain do |expected|
  match do |obj|
    obj.include?(expected)
  end
end

RSpec::Matchers.define :exclude do |expected|
  match do |obj|
    not obj.include?(expected)
  end
end
