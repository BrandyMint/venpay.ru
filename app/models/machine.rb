require 'securerandom'

class Machine < ApplicationRecord
  nilify_blanks

  AVAILABLE_ADAPTERS = [RovosAdapter, SmsAdapter]

  belongs_to :account
  has_many :activities
  has_many :payments

  validates :internal_id, presence: true, uniqueness: { scope: [:account_id] }
  validates :public_number, presence: true, uniqueness: { scope: [:account_id] }, length: { is: 6 }, format: { with: /\A\d+\z/, message: "Разрешены только цифры" }
  validates :slug, presence: true, uniqueness: true
  validates :location, presence: true
  validates :adapter_class, presence: true, inclusion: { in: AVAILABLE_ADAPTERS.map(&:to_s) }
  validates :phone, phone: { allow_blank: true }

  before_validation on: :create do
    self.slug ||= SecureRandom.hex(3)
  end

  before_validation do
    self.internal_id = internal_id.to_s.strip.chomp
    self.public_number = public_number.to_s.strip.chomp
    self.phone = phone.to_s.strip.chomp.presence
  end

  after_commit :generate_qr_code, on: :create

  def adapter
    adapter_class.constantize.new(self)
  end

  def generate_qr_code
    QrCodeGenerator.for_machine(self).generate_svg
  end
end
