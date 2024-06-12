class Order < ApplicationRecord
  MONEY_THRESHOLD = 100_000_000
  MONEY_VALIDATION = {
    presence: true,
    numericality: {
      greater_than: -MONEY_THRESHOLD,
      less_than: MONEY_THRESHOLD,
      allow_blank: true
    },
    format: { with: /\A-?\d+(?:\.\d{1,2})?\z/, allow_blank: true }
  }.freeze

  POSITIVE_MONEY_VALIDATION = MONEY_VALIDATION.deep_dup.tap do |validation|
    validation.fetch(:numericality)[:greater_than_or_equal_to] = 0
  end.freeze

  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items

  belongs_to :client, optional: true

  validates :token, presence: true
  validates :item_total, POSITIVE_MONEY_VALIDATION
  validates :total,      POSITIVE_MONEY_VALIDATION

  scope :incomplete, -> { where(completed_at: nil) }
  scope :complete, -> { where.not(completed_at: nil) }

  def completed?
    completed_at.present?
  end

  def self.find_order_by_token_or_user(token, user)
    return unless token || user

    if token
      Order.find_by(token:)
    elsif user
      user.orders.incomplete.first
    end
  end

  def calcule_totals
    update_item_count
    update_item_total

    save!
  end

  private

  def update_item_total
    self.total = line_items.sum('price * quantity')
  end

  def update_item_count
    self.item_count = line_items.sum(:quantity)
  end
end
