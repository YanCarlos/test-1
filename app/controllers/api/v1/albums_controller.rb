module Api
  module V1
    class AlbumsController < BaseController
      before_action :set_artist, only: :index

      def index
        albums = @artist.albums

        json_response(albums, albums.count, :ok)
      end

      private

      def set_artist
        @artist = Artist.find(params[:id])
      end
    end
  end
end
