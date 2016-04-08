class ApiTimesheetsController < BaseApiController
  skip_before_filter  :verify_authenticity_token

  before_filter only: :create do
    parse_request
    unless @json.has_key?('timesheet') && @json['timesheet']['in'] && @json['timesheet']['employer_id'] && @json['timesheet']['employee_id']
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
    if(@json.has_key?(:day))
      week = @json['timesheet']['day'].to_i
      begin_date = DateTime.new(year, month, day, 00, 00, 00)
      end_date = begin_date + 1.week
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
    if @timesheet.save
      render json: @timesheet
    else
       render nothing: true, status: :bad_request
    end
  end

end