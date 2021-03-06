class ApiTimesheetsController < BaseApiController
  skip_before_filter  :verify_authenticity_token

  before_filter only: :create do
    parse_request
    unless @json.has_key?('timesheet') && @json['timesheet']['in']
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :index do
    parse_request
    unless @json.has_key?('timesheet') && @json['timesheet']['year'] && @json['timesheet']['month'] && @json['timesheet']['start_day'] && @json['timesheet']['end_day']
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :update do
    parse_request
    unless @json.has_key?('timesheet') && @json['timesheet']['id'] && @json['timesheet']['year'] && @json['timesheet']['month'] && @json['timesheet']['day'] && @json['timesheet']['hour'] && @json['timesheet']['minute'] && @json['timesheet']['second']
      render nothing: true, status: :bad_request
    end
    find_timesheet
  end

  def index
    year = @json['timesheet']['year'].to_i
    month = @json['timesheet']['month'].to_i
    start_day = @json['timesheet']['start_day'].to_i
    end_day = @json['timesheet']['end_day'].to_i
    begin_date = DateTime.new(year, month, start_day, 00, 00, 00)
    end_date = DateTime.new(year, month, end_day, 00, 00, 00)
    if(params.has_key?(:employer_id))
      render json: Timesheet.where(employer_id: params[:employer_id], created_at: begin_date..end_date)
    elsif(params.has_key?(:employee_id))
      render json: Timesheet.where(employee_id: params[:employee_id], created_at: begin_date..end_date)
    else
      render nothing: true, status: :bad_request
    end

  end

  def create
    @timesheet = Timesheet.new
    @timesheet.assign_attributes(@json['timesheet'])
    @timesheet.employee_id = params[:employee_id]
    @timesheet.employer_id = Employer.find(Employee.find(1).employer_id).id
    if @timesheet.save
      render json: @timesheet
    else
       render nothing: true, status: :bad_request
    end
  end

  def update
    year = @json['timesheet']['year'].to_i
    month = @json['timesheet']['month'].to_i
    day = @json['timesheet']['day'].to_i
    hour = @json['timesheet']['hour'].to_i
    minute = @json['timesheet']['minute'].to_i
    second = @json['timesheet']['second'].to_i
    timesheet_time = DateTime.new(year, month, day, hour, minute, second)
    timesheet_time = timesheet_time.in_time_zone(Time.zone)
    @timesheet.created_at = timesheet_time
    if @timesheet.save
      render json: @timesheet
    else
      render nothing: true, status: :bad_request
    end
  end

   private
     def find_timesheet
       @timesheet = Timesheet.find(@json['timesheet']['id'])
       render nothing: true, status: :not_found unless @timesheet.present?
     end

end