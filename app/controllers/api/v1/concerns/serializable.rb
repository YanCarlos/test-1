module Api::V1
  module Concerns
    module Serializable
      extend ActiveSupport::Concern

      def serialize(object)
        ActiveModelSerializers::SerializableResource.new(object).as_json
      end
    end
  end
end
