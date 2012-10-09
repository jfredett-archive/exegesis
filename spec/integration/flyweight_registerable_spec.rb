require 'integration_spec_helper'

describe Flyweight, "mixin", "other objects" do
  before do
    class Example
      include Registerable
      def initialize(parent, name, *args)
        @parent = parent
        @name = name
        @args = args
      end

      attr_reader :parent, :name

      def self.build_path(parent, child)
        [parent.path, child].join('/')
      end
    end

    class ParentObject
      def path
        "the_parent_path"
      end
    end
  end

  let(:parent) { ParentObject.new }

  after do
    Object.send(:remove_const, :Example)
    Object.send(:remove_const, :ParentObject)
  end

  describe 'api' do
    context 'class' do
      subject { Example }
      it { should respond_to :create }

      context 'required' do
        it { should respond_to :build_path }
      end
    end

    context 'instance' do
      subject { Example.send(:new, parent, 'n') } # to test instance API
      it { should respond_to :path }
    end
  end

  describe 'instantiation' do
    it 'disallows instantiation via #new' do
      expect { Example.new(parent, 'n') }.to raise_error NoMethodError
    end
  end

  describe 'creating a new instance' do
    subject { Example.create(parent, 'n') }
  end

  describe 'creating an instance that is already registered' do
    let!(:existing_entry) { Example.create(parent, 'n') }
    subject               { Example.create(parent, 'n') }

    it { should be existing_entry }
  end

  describe 'deleting an instance' do
  end

  describe 'retrieving an already created instance' do
    context 'via #create' do
    end

    #find semantics, something like ['/foo/bar']
    context 'via #[]' do
    end
  end
end
