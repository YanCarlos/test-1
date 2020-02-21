module Api
  module V1
    class ArtistsController < ApplicationController
      def index
        render json: Artist.ordered_by_popularity, status: :ok 
      end
    end
  end
end
