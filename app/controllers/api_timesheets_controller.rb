class ApiTimesheetsController < BaseApiController
  skip_before_filter  :verify_authenticity_token

  before_filter only: :create do
    parse_request
    unless @json.has_key?('timesheet') && @json['timesheet']['in']
      render "no key", status: :bad_request
    end
  end

  before_filter only: :index do
    parse_request
    unless @json.has_key?('timesheet') && @json['timesheet']['year'] && @json['timesheet']['month']
      render nothing: true, status: :bad_request
    end
  end

  def index
    year = @json['timesheet']['year']
    month = @json['timesheet']['month']
    if(@json.has_key?(:day))
      week = @json['timesheet']['day']
      begin_date = DateTime.new(year, month, day, 00, 00, 00)
      end_date = begin_date + 1.week + 1.day
    else
      begin_date = DateTime.new(year, month, 01, 00, 00, 00)
      end_date = begin_date + 1.month + 1.day
    end
    if(params.has_key?(:employer_id))
      render json: Timesheet.where(employer_id: params[:employer_id], time: begin_date..end_date)
    else
      render json: Timesheet.where(employee_id: params[:employee_id], time: begin_date..end_date)
    end

  end

  def create
    @timesheet = Timesheet.new(employee_id: params[:employee_id], employer_id: Employee.find(params[:employee_id]).employer.id)
    @timesheet.assign_attributes(@json['timesheet'])
    if @timesheet.save
      render json: @timesheet
    else
       render "did not save", status: :bad_request
    end
  end

end