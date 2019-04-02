class TimePlan < ApplicationRecord
  include RailsBookingRecurrence

  attribute :room_id, :integer

  belongs_to :room, optional: true
  belongs_to :plan, polymorphic: true
  belongs_to :time_item, optional: true
  belongs_to :time_list, optional: true
  delegate :start_at, :finish_at, to: :time_item, allow_nil: true


end
