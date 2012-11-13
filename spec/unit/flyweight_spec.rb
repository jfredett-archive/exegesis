require 'unit_spec_helper'

describe Flyweight do
  let (:processor)          { proc { |instance| instance_key }  }
  let (:flyweight)          { Flyweight.new(&processor)         }
  let (:instance)           { double('instance')                }
  let (:instance_key)       { double('instance_key')            }

  subject { flyweight }

  context 'shared examples' do
    shared_examples_for 'flyweight unregistration' do
      before { flyweight.unregister!(key) }

      it { should_not have_key instance_key }
      it { should_not have_key instance }

      describe 'unregistering an unused key' do
        it 'raises an error' do
          expect { flyweight.unregister!(key) }.to raise_error Flyweight::NoEntryError
        end

        describe '#unregister' do
          it 'raises an error' do
            expect { flyweight.unregister(key) }.to_not raise_error Flyweight::NoEntryError
          end
        end
      end
    end
  end

  describe 'api' do
    it { should respond_to :register! }
    it { should respond_to :unregister! }
    it { should respond_to :[] }

    it { should respond_to :has_key? }

    it { should respond_to :clear! }
    it { should respond_to :reset! }
  end

  describe 'implementation' do
    before { flyweight.register!(instance) }

    describe '#register! and #register' do
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

    describe '#has_key?' do
      subject { flyweight }

      context 'when it has an entry for the given value' do
        before { flyweight.register(instance) }

        context 'by key' do
          it { should have_key instance_key }
        end

        context 'by instance' do
          it { should have_key instance }
        end
      end

      context 'when it has no entry for the given value' do
        before { flyweight.clear! }

        context 'by key' do
          it { should_not have_key instance_key }
        end

        context 'by instance' do
          it { should_not have_key instance }
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

      describe 'when flyweight does not have an entry for the value' do
        before { flyweight.clear! }

        context 'by instance' do
          subject { flyweight[instance] }

          it { should be_nil }
        end

        context 'by key' do
          subject { flyweight[instance_key] }

          it { should be_nil }
        end

      end
    end

    describe '#unregister!' do
      context 'by key' do
        let (:key) { instance_key }
        it_behaves_like 'flyweight unregistration'
      end

      context 'by instance' do
        let (:key) { instance }
        it_behaves_like 'flyweight unregistration'
      end
    end
  end
end
