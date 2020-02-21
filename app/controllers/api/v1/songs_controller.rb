module Api
  module V1
    class SongsController < BaseController
      before_action :set_album, only: :index

      def index
        songs = @album.songs

        json_response(songs, songs.count, :ok)
      end

      private

      def set_album
        @album = Album.find(params[:id])
      end
    end
  end
end
