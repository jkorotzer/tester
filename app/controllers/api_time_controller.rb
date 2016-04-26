class ApiTimeController < BaseApiController
  skip_before_filter  :verify_authenticity_token

  before_filter only: :index do
    parse_request
    unless @json.has_key?('time') && @json['time']['year'] && @json['time']['month'] && @json['time']['day']
      render nothing: true, status: :bad_request
    end
    makeDate
  end

  def index
    timesheets = Timesheet.where(employee_id: params[:employee_id], created_at: @begin_date..@end_date).sort_by{|t| t.created_at}
    last_time = @begin_date
    last_timesheet_was_in = false
    total_time = 0
    timesheets.each do |timesheet|
      puts "timesheet"
      if timesheet.in
        puts "timesheet in"
        if !last_timesheet_was_in
          last_time = timesheet.created_at
          puts last_time
          last_timesheet_was_in = true
        end
      else
        if last_timesheet_was_in
          total_time = total_time + TimeDifference.between(last_time, timesheet.created_at).in_seconds
          puts total_time
          last_timesheet_was_in = false
        end
      end
    end
    render json: total_time
  end

  private
    def makeDate
      year = @json['time']['year'].to_i
      month = @json['time']['month'].to_i
      day = @json['time']['day'].to_i
      @begin_date = DateTime.new(year, month, day, 00, 00, 00)
      @end_date = @begin_date + 1.day
    end

end