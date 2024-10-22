class Todo < ApplicationRecord
  after_initialize :set_default_values
  belongs_to :user
  belongs_to :category_master
  validates :title, presence: true
  validates :description, presence: true
  validate :due_date_is_date?
  # validate :start_date_is_date?

  def with_category
    todo = self.attributes
    if self.category_master && self.category_master.category_name.present?
      todo["category"] = self.category_master.category_name
    else
      todo["category"] = "No Category"
    end
    todo
  end

  private

  # set initial value
  def set_default_values
    self.completed ||= false
  end

  def due_date_is_date?
    begin
      self.due_date = Date.parse(due_date) unless due_date.is_a?(Date)
    rescue ArgumentError
      error.add(:due_date, 'must be a valid date')
    end
  end

  def due_date_is_date?
    begin
      self.start_date = Date.parse(start_date) unless start_date.is_a?(Date)
    rescue ArgumentError
      error.add(:start_date, 'must be a valid date')
    end
  end
end
