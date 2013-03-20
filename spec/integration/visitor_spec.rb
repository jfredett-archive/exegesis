require 'integration_spec_helper'

describe '#visit' do
  let (:dir) { Exegesis::BaseDirectory.create('./spec/fake_project') }

  context 'visitor with a proc' do
    subject { proc { } }

    before do
      subject.stub(:call)

      dir.visit(subject)
    end


    it { should have_received(:call).with(dir.class, dir) }
    it { should_not have_received(:on_enter) }
    it { should_not have_received(:on_exit) }
  end

  context 'visitor with a class' do
    let (:visitor) { double('visitor instance') }
    subject { visitor }

    before do
      visitor.stub(:call)
    end

    describe 'a visitor class with no hooks defined' do
      before do
        visitor.stub(:respond_to?).with(:on_enter).and_return(false)
        visitor.stub(:respond_to?).with(:on_exit).and_return(false)

        dir.visit(visitor)
      end

      it { should have_received(:call).with(dir.class, dir) }
      it { should_not have_received(:on_enter) }
      it { should_not have_received(:on_exit) }
    end

    describe 'a visitor class with the #on_enter hook defined' do
      before do
        visitor.stub(:respond_to?).with(:on_enter).and_return(true)
        visitor.stub(:respond_to?).with(:on_exit).and_return(false)
        visitor.stub(:on_enter)

        dir.visit(visitor)
      end

      it { should have_received(:call).with(dir.class, dir) }
      it { should have_received(:on_enter) }
      it { should_not have_received(:on_exit) }
    end

    describe 'a visitor class with the #on_exit hook defined' do
      before do
        visitor.stub(:respond_to?).with(:on_enter).and_return(false)
        visitor.stub(:respond_to?).with(:on_exit).and_return(true)
        visitor.stub(:on_exit)

        dir.visit(visitor)
      end


      it { should have_received(:call).with(dir.class, dir) }
      it { should_not have_received(:on_enter) }
      it { should have_received(:on_exit) }
    end

    describe 'a visitor class with the both hooks defined' do
      before do
        visitor.stub(:respond_to?).with(:on_enter).and_return(true)
        visitor.stub(:respond_to?).with(:on_exit).and_return(true)
        visitor.stub(:on_enter)
        visitor.stub(:on_exit)

        dir.visit(visitor)
      end

      it { should have_received(:call).with(dir.class, dir) }
      it { should have_received(:on_enter) }
      it { should have_received(:on_exit) }
    end
  end
end
