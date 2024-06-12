# spec/models/order_spec.rb
require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { build(:order) }
  let(:client) { create(:client) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(order).to be_valid
    end

    it 'is not valid without a token' do
      order.token = nil
      expect(order).to_not be_valid
    end

    it 'is not valid with a negative item total' do
      order.item_total = -1
      expect(order).to_not be_valid
    end

    it 'is valid with a zero item total' do
      order.item_total = 0
      expect(order).to be_valid
    end

    it 'is not valid with a negative total' do
      order.total = -1
      expect(order).to_not be_valid
    end
  end

  context 'associations' do
    it { should have_many(:line_items).dependent(:destroy) }
    it { should have_many(:products).through(:line_items) }
    it { should belong_to(:client).optional }
  end

  context 'scopes' do
    it 'includes incomplete orders' do
      incomplete_order = create(:order, completed_at: nil)
      expect(Order.incomplete).to include(incomplete_order)
    end

    it 'includes complete orders' do
      complete_order = create(:order, completed_at: Time.current)
      expect(Order.complete).to include(complete_order)
    end
  end

  context 'methods' do
    describe '#completed?' do
      it 'returns true if completed_at is present' do
        order.completed_at = Time.current
        expect(order.completed?).to be true
      end

      it 'returns false if completed_at is nil' do
        order.completed_at = nil
        expect(order.completed?).to be false
      end
    end

    describe '.find_order_by_token_or_user' do
      it 'finds order by token' do
        order.save!
        expect(Order.find_order_by_token_or_user(order.token, nil)).to eq(order)
      end

      it 'finds incomplete order by user' do
        order.client = client
        order.save!
        expect(Order.find_order_by_token_or_user(nil, client)).to eq(order)
      end
    end

    describe '#calcule_totals' do
      let(:product) { create(:product, price: 10) }
      let!(:line_item) { create(:line_item, order:, product:, quantity: 2) }

      it 'updates item count' do
        expect(order.item_count).to eq(2)
      end
    end
  end
end
