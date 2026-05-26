class Todo < ApplicationRecord
  scope :overdue, -> { where.not(due_date: nil).where("due_date < ?", Time.current) }
  scope :upcoming, -> { where.not(due_date: nil).where(due_date: Time.current..7.days.from_now) }
end
