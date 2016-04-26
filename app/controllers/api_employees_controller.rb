class ApiEmployeesController < BaseApiController
  skip_before_filter  :verify_authenticity_token

  before_filter :find_employee, only: [:show, :update]

  before_filter only: :create do
    parse_request
    unless @json.has_key?('employee') && @json['employee']['employer_id'] && @json['employee']['name'] && @json['employee']['password']
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :update do
    parse_request
    unless @json.has_key?('employee')
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :create do
    @employee = Employee.find_by_name(@json['employee']['name'])
  end

  def index
    render json: Employee.all
  end

  def show
    render json: @employee
  end

  def create
    if @employee.present?
      render nothing: true, status: :conflict
    else
      @employee = Employee.new
      @employee.assign_attributes(@json['employee'])
      if @employee.save
        json = { :employee => @employee, :addresses => @employee.employer.addresses }.to_json
        render json: json
      else
         render nothing: true, status: :bad_request
      end
    end
  end

  def update
    @employee.assign_attributes(@json['employee'])
    if @employee.save
        render json: @employee
    else
        render nothing: true, status: :bad_request
    end
  end

 private
   def find_employee
     @employee = Employee.find_by_id(params[:employee_id])
     render nothing: true, status: :not_found unless @employee.present?
   end
end