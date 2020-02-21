module Api
  module V1
    class GenresController < BaseController
      before_action :set_song, only: :random_song

      def random_song
        json_response(@song, @song.present? ? 1 : 0, :ok)
      end

      private

      def set_song
        @song = Song.random_by_genre(params[:genre_name])[0] || {}
      end
    end
  end
end
