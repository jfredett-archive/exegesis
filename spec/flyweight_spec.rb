require 'spec_helper'

describe Flyweight do
  let (:processor)          { proc { instance_key }     }  
  let (:flyweight)          { Flyweight.new(&processor) }
  let (:instance)           { double('instance')        }
  let (:instance_key)       { double('instance_key')    }

  subject { flyweight } 

  before do
    processor.stub(:call).and_return(instance_key)
    flyweight.register!(instance) 
  end

  describe 'api' do
    it { should respond_to :register! } 
    it { should respond_to :unregister! } 
    it { should respond_to :[] } 

    it { should respond_to :has_key? }

    it { should respond_to :clear! } 
    it { should respond_to :reset! } 
  end

  describe '#register!' do
    the(:processor) { should have_received(:call).with(instance) } 

    describe 'registering an instance with an already-used key' do
      it 'raises an error' do
        expect { flyweight.register!(instance) }.to raise_error Flyweight::AlreadyRegisteredError
      end

      describe '#register' do
        it 'does not raise an error' do
          expect { flyweight.register(instance) }.to_not raise_error Flyweight::AlreadyRegisteredError
        end
      end
    end
  end

  describe '#[]' do
    context 'by instance' do
      subject { flyweight[instance] }

      it { should be instance }
    end

    context 'by key' do
      subject { flyweight[instance_key] }

      it { should be instance } 
    end
  end

  describe '#unregister!' do
    context 'by key' do
      before { flyweight.unregister!(instance_key) } 

      it { should_not have_key instance_key } 
      it { should_not have_key instance }

      describe 'unregistering an unused key' do
        it 'raises an error' do
          expect { flyweight.unregister!(instance_key) }.to raise_error Flyweight::NoEntryError
        end

        describe '#unregister' do
          it 'raises an error' do
            expect { flyweight.unregister(instance_key) }.to_not raise_error Flyweight::NoEntryError 
          end
        end
      end
    end

    context 'by instance' do
      before { flyweight.unregister!(instance) } 

      it { should_not have_key instance_key } 
      it { should_not have_key instance }

      describe 'unregistering an unused key' do
        it 'raises an error' do
          expect { flyweight.unregister!(instance) }.to raise_error Flyweight::NoEntryError
        end

        describe '#unregister' do
          it 'raises an error' do
            expect { flyweight.unregister(instance) }.to_not raise_error Flyweight::NoEntryError
          end
        end
      end
    end
  end
end
