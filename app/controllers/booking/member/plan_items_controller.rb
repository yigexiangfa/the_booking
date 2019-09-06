class Booking::Member::PlanItemsController < Booking::Member::BaseController
  #before_action :set_course_plan, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {
      'plan_on-gte': Date.today,
      teacher_id: current_member.id
    }
    q_params.merge! 'plan_on-gte': params[:start_date] if params[:start_date]
    q_params.merge! 'plan_on-lte': params[:end_date] if params[:end_date]

    q_params.merge! params.permit(:place_id)

    @plan_items = PlanItem.includes(:place, :teacher, :course, :time_item, :crowd).default_where(q_params).order(plan_on: :asc).page(params[:page]).per(params[:per])

    respond_to do |format|
      format.html
      format.js
      format.json { render json: { events: @plan_items.map(&:to_event) } }
    end
  end

  def plan
    set_time_lists
    q_params = {}
    q_params.merge! params.permit(:place_id)
    @time_plans = @course_crowd.time_plans.default_where(q_params)

    @time_plan = @course_crowd.time_plans.find_or_initialize_by(q_params.slice(:place_id))
    @time_plan.time_list ||= TimeList.default
  end

  def show
  end

  def edit
  end

  def update
    @course_plan.assign_attributes(course_plan_params)

    respond_to do |format|
      if @course_plan.save
        format.html.phone
        format.html { redirect_to admin_course_crowd_plans_url(@course_crowd) }
        format.js { redirect_back fallback_location: admin_course_crowd_plans_url(@course_crowd) }
        format.json { render :show }
      else
        format.html.phone { render :edit }
        format.html { render :edit }
        format.js { redirect_back fallback_location: admin_course_crowd_plans_url(@course_crowd) }
        format.json { render :show }
      end
    end
  end

  def destroy
    @course_plan.destroy
    redirect_to admin_course_crowd_plans_url(@course_crowd)
  end

  private
  def set_course_plan
    @course_plan = PlanItem.find(params[:id])
  end

  def course_plan_params
    params.fetch(:course_plan, {}).permit(
      :lesson_id,
      :place_id
    )
  end

end
