module Api
  module V1
    class BaseController < ApplicationController
      include Concerns::ResponseHandler
      include Concerns::ExceptionHandler
    end
  end
end
