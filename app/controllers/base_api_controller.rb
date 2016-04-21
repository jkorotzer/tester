class BaseApiController < ApplicationController
  
  private
    def parse_request
      @json = JSON.parse(request.body.read)
    end
  
end