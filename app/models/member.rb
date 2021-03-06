class Member < ApplicationRecord
  belongs_to :group
  before_create :generate_code
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :allergies, length: { maximum: 250 }
  private

  def generate_code
      self.member_code = generate_member_code
  end

  def generate_member_code
      loop do 
          member_code = SecureRandom.hex(3)
          break member_code unless Member.where(member_code: member_code).exists?
      end
  end

end
