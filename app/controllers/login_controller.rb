class LoginController < BaseApiController

    skip_before_filter  :verify_authenticity_token

    before_filter only: :index do
      parse_request
      unless @json.has_key?('name') && @json.has_key?('password')
        render nothing: true, status: :bad_request
        end
    end

    def index
      @employee = Employee.find_by_name(@json['username'])
      if @employee.present?
        render json: @employee.valid_password?(@json['password'])
      else
        render nothing: true, status: :bad_request
      end
    end

end