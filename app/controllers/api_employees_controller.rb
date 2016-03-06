class ApiEmployeesController < BaseApiController
  skip_before_filter  :verify_authenticity_token
  before_filter :find_employee, only: [:show, :update]

  before_filter only: :create do
    unless @json.has_key?('employee') && @json['employee']['address']
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :update do
    unless @json.has_key?('employee')
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :create do
    @employee = Employee.find_by_id(@json['employee']['id'])
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
        render json: @employee
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
     @employee = Employee.find_by_id(params[:id])
     render nothing: true, status: :not_found unless @employee.present?
   end
end