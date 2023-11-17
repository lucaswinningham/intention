shared_examples 'writable' do |attribute, flag = nil|
  let(:setter) { "#{attribute}=" }
  let(:instance) { subject.new }

  if flag.nil?
    it 'allows attribute to be written publicly' do
      expect(instance.respond_to?(setter)).to be(true)
    end

    it 'allows attribute to be written privately' do
      expect(instance.respond_to?(setter, true)).to be(true)
    end
  elsif flag == :privately
    it 'does not allow attribute to be written publicly' do
      expect(instance.respond_to?(setter)).to be(false)
    end

    it 'allows attribute to be written privately' do
      expect(instance.respond_to?(setter, true)).to be(true)
    end
  elsif flag == false
    it 'does not allow attribute to be written publicly' do
      expect(instance.respond_to?(setter)).to be(false)
    end

    it 'does not allow attribute to be written privately' do
      expect(instance.respond_to?(setter, true)).to be(false)
    end
  end
end
