module Api::V1
  module Concerns
    module ResponseHandler
      extend ActiveSupport::Concern
      include Serializable

      def json_response(object, object_count = 0, status = :ok)
        serialized_object = serialize(object)
        response.headers['X-Total-Count'] = object_count
        response.headers['Access-Control-Expose-Headers'] = 'X-Total-Count'
        render json: { data: serialized_object }, status: status
      end
    end
  end
end
