module RailsBooking::Plan
  extend ActiveSupport::Concern

  included do
    attribute :title, :string

    belongs_to :planned, polymorphic: true

    has_many :plan_times
    accepts_nested_attributes_for :plan_times
    
    has_many :plan_items, as: :plan
  end

  def default_time_plan(params)
    time_plans.find_or_initilaze_by(
      place_id: params[:place_id],
      begin_on: params[:begin_on],
      end_on: params[:end_on]
    )
  end

end
