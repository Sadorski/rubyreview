class User < ActiveRecord::Base
  validates :first_name, :last_name, :presence => true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: {minimum: 8}, on: :create
  has_many :events
  has_many :comments
  has_many :attendees
  has_many :events_attended, through: :attendees, source: :event
  before_save :downcase_email
  belongs_to :location
  has_secure_password
  def downcase_email 
    self.email = self.email.downcase
  end
end
