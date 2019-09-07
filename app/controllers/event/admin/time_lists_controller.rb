class Event::Admin::TimeListsController < Event::Admin::BaseController
  before_action :set_time_list, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}
    q_params.merge! default_params
    @time_lists = TimeList.default_where(q_params).order(id: :asc).page(params[:page])
  end

  def new
    @time_list = TimeList.new
  end

  def create
    @time_list = TimeList.new(time_list_params)

    respond_to do |format|
      if @time_list.save
        format.html.phone
        format.html { redirect_to admin_time_lists_url }
        format.js { redirect_back fallback_location: admin_time_lists_url }
        format.json { render :show }
      else
        format.html.phone { render :new }
        format.html { render :new }
        format.js
        format.json { render :show }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @time_list.assign_attributes(time_list_params)

    respond_to do |format|
      if @time_list.save
        format.html.phone
        format.html { redirect_to admin_time_lists_url }
        format.js { redirect_back fallback_location: admin_time_lists_url }
        format.json { render :show }
      else
        format.html.phone { render :edit }
        format.html { render :edit }
        format.js
        format.json { render :show }
      end
    end
  end

  def destroy
    @time_list.destroy
    redirect_to admin_time_lists_url
  end

  private
  def set_time_list
    @time_list = TimeList.find(params[:id])
  end

  def time_list_params
    p = params.fetch(:time_list, {}).permit(
      :name,
      :code,
      :interval_minutes,
      :item_minutes,
      :default
    )
    p.merge! default_form_params
  end

end