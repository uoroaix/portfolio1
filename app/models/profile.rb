class Profile < ActiveRecord::Base
  belongs_to :user
  validates :user_id, uniqueness: true

  delegate :email, to: :user

  def full_name
    if first_name || last_name
      "#{first_name} #{last_name} ".squeeze(" ").strip
    else
      email
    end
  end
  
end
