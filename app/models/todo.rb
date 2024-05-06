class Todo < ApplicationRecord
  after_initialize :set_default_values
  belongs_to :user
  validates :title, presence: true
  validates :description, presence: true

  private

  # set initial value
  def set_default_values
    self.completed ||= false
  end
end
