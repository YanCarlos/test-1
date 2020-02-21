module Api::V1
  module Concerns
    module ExceptionHandler
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveRecord::RecordNotFound do |e|
          json_response({ message: e.message }, 0, :not_found)
        end
      end
    end
  end
end
