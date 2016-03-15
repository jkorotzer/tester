class ApiAddressesController < BaseApiController
  skip_before_filter  :verify_authenticity_token

  before_filter :find_address, only: [:show, :update]

  before_filter only: :create do
    parse_request
    unless @json.has_key?('address') && @json['address']['address'] && @json['address']['employer_id']
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :update do
    parse_request
    unless @json.has_key?('address')
      render nothing: true, status: :bad_request
    end
  end

  #before_filter only: :create do
    #@address = Address.find_by_address(@json['address']['address'])
  #end

  def index
    render json: Address.where(employer_id: params[:employer_id])
  end

  def show
    render json: @address
  end

  def create
    @address = Address.new
    @address.assign_attributes(@json['address'])
    if @address.save
      render json: @address
    else
       render nothing: true, status: :bad_request
    end
  end

  def update
    @address.assign_attributes(@json['address'])
    if @address.save
        render json: @address
    else
        render nothing: true, status: :bad_request
    end
  end

 private
   def find_address
     @address = Address.where(employer_id: params[:employer_id], address: params[:address])
     render nothing: true, status: :not_found unless @address.present?
   end
end