class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  has_many :comments
  has_many :attendees
  has_many :attended, through: :attendees, source: :user 
  validates :name, :user, :date, presence: true
  validate :event_date_cannot_be_in_the_past

  private
  def event_date_cannot_be_in_the_past
    errors.add(:date, "can't be in the past") if !date.blank? and date < Date.today
  end 
end
