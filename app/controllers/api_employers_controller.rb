class ApiEmployersController < BaseApiController
  skip_before_filter  :verify_authenticity_token

  before_filter :find_employer, only: [:show, :update]

  before_filter only: :create do
    parse_request
    unless @json.has_key?('employer') && @json['employer']['name'] && @json['employer']['password'] && @json['employer']['company_name']
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :update do
    parse_request
    unless @json.has_key?('employer')
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :create do
    @employer = Employer.find_by_id(@json['employer']['id'])
  end

  def index
    render json: Employer.all
  end

  def show
    render json: @employer
  end

  def create
    if @employer.present?
      render nothing: true, status: :conflict
    else
      @employer = Employer.new
      @employer.assign_attributes(@json['employer'])
      if @employer.save
        render json: @employer
      else
         render nothing: true, status: :bad_request
      end
    end
  end

  def update
    @employer.assign_attributes(@json['employer'])
    if @employer.save
        render json: @employer
    else
        render nothing: true, status: :bad_request
    end
  end

 private
   def find_employer
     @employer = Employer.find_by_id(params[:employer_id])
     render nothing: true, status: :not_found unless @employer.present?
   end
end