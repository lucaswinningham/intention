shared_examples 'writable' do |attribute, flag = nil|
  let(:setter) { "#{attribute}=" }
  let(:instance) { subject.new }

  if flag.nil?
    it 'allows attribute to be written publicly' do
      expect { instance.public_send(setter, attribute) }.not_to raise_error
    end

    it 'allows attribute to be written privately' do
      expect { instance.__send__(setter, attribute) }.not_to raise_error
    end
  elsif flag == :privately
    it 'does not allow attribute to be written publicly' do
      expect { instance.public_send(setter, attribute) }.to raise_error(NoMethodError)
    end

    it 'allows attribute to be written privately' do
      expect { instance.__send__(setter, attribute) }.not_to raise_error
    end
  elsif flag == false
    it 'does not allow attribute to be written publicly' do
      expect { instance.public_send(setter, attribute) }.to raise_error(NoMethodError)
    end

    it 'does not allow attribute to be written privately' do
      expect { instance.__send__(setter, attribute) }.to raise_error(NoMethodError)
    end
  end
end
