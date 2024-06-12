require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:client) { build(:client) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(client).to be_valid
    end

    it 'is not valid without a nombre' do
      client.nombre = nil
      expect(client).to_not be_valid
    end

    it 'is not valid without an email' do
      client.email = nil
      expect(client).to_not be_valid
    end

    it 'is not valid with a duplicate email' do
      create(:client, email: client.email)
      expect(client).to_not be_valid
    end

    it 'is not valid with an invalid email format' do
      client.email = 'invalid_email'
      expect(client).to_not be_valid
    end
  end

  context 'associations' do
    it { should have_many(:orders).dependent(:nullify) }
  end
end
