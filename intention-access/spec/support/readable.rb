shared_examples 'readable' do |attribute, flag = nil|
  let(:getter) { attribute }
  let(:instance) { subject.new }

  if flag.nil?
    it 'allows attribute to be read publicly' do
      expect { instance.public_send(getter) }.not_to raise_error
    end

    it 'allows attribute to be read privately' do
      expect { instance.__send__(getter) }.not_to raise_error
    end
  elsif flag == :privately
    it 'does not allow attribute to be read publicly' do
      expect { instance.public_send(getter) }.to raise_error(NoMethodError)
    end

    it 'allows attribute to be read privately' do
      expect { instance.__send__(getter) }.not_to raise_error
    end
  elsif flag == false
    it 'does not allow attribute to be read publicly' do
      expect { instance.public_send(getter) }.to raise_error(NoMethodError)
    end

    it 'does not allow attribute to be read privately' do
      expect { instance.__send__(getter) }.to raise_error(NoMethodError)
    end
  end
end
