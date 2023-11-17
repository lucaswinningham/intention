shared_examples 'readable' do |attribute, flag = nil|
  let(:getter) { attribute }
  let(:instance) { subject.new }

  if flag.nil?
    it 'allows attribute to be read publicly' do
      expect(instance.respond_to?(getter)).to be(true)
    end

    it 'allows attribute to be read privately' do
      expect(instance.respond_to?(getter, true)).to be(true)
    end
  elsif flag == :privately
    it 'does not allow attribute to be read publicly' do
      expect(instance.respond_to?(getter)).to be(false)
    end

    it 'allows attribute to be read privately' do
      expect(instance.respond_to?(getter, true)).to be(true)
    end
  elsif flag == false
    it 'does not allow attribute to be read publicly' do
      expect(instance.respond_to?(getter, true)).to be(false)
    end

    it 'does not allow attribute to be read privately' do
      expect(instance.respond_to?(getter, true)).to be(false)
    end
  end
end
