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
    unless @json.has_key?('timesheet') && @json['timesheet']['year'] && @json['timesheet']['month']
      render nothing: true, status: :bad_request
    end
  end

  def index
    year = @json['timesheet']['year'].to_i
    month = @json['timesheet']['month'].to_i
    if(@json.has_key?(:week))
      week = @json['timesheet']['week'].to_i
      begin_date = DateTime.new(year, month, week, 00, 00, 00)
      end_date = begin_date + 1.week
    elsif(@json.has_key?(:day))
      day = @json['timesheet']['day'].to_i
      begin_date = DateTime.new(year, month, day, 00, 00, 00)
      end_date = begin_date + 1.day
    else
      begin_date = DateTime.new(year, month, 01, 00, 00, 00)
      end_date = begin_date + 1.month
    end
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

end