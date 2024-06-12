require 'rails_helper'

RSpec.describe LineItem, type: :model do
  let(:product) { create(:product, stock: 10) }
  let(:order) { create(:order) }
  let(:line_item) { build(:line_item, product:, order:) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(line_item).to be_valid
    end

    it 'is not valid without a quantity' do
      line_item.quantity = nil
      expect(line_item).to_not be_valid
    end

    it 'is not valid with a negative quantity' do
      line_item.quantity = -1
      line_item.valid?
      expect(line_item.errors[:quantity]).to include('must be greater than 0')
    end
  end

  describe 'callbacks' do
    it 'sets the price before validation' do
      line_item.valid?
      expect(line_item.price).to eq(product.price * line_item.quantity)
    end

    it 'ensures a valid quantity before validation' do
      line_item.quantity = -1
      line_item.valid?
      expect(line_item.quantity).to eq(0)
    end

    it 'adjusts stock after save' do
      line_item.quantity = 1

      expect do
        line_item.save!
      end.to change { product.reload.stock }.by(-line_item.quantity)
    end

    it 'returns stock after destroy' do
      line_item.save!
      expect do
        line_item.destroy
      end.to change { product.reload.stock }.by(line_item.quantity)
    end

    it 'adjusts order totals after save' do
      expect(order).to receive(:calcule_totals)
      line_item.save!
    end

    it 'adjusts order totals after destroy' do
      line_item.save!
      expect(order).to receive(:calcule_totals)
      line_item.destroy
    end
  end
end
