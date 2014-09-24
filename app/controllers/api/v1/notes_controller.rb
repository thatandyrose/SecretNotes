
module Api
  module V1

    class NotesController < ApplicationController
     respond_to :json

      def show
        @note = Note.authenticate(params[:id], params.require(:password))
        
        if !@note
          render json: {message: 'Could not authenticate'}, status: :bad_request
        end
      end

      def create
        @note = Note.new(params.require(:note).permit(:title, :body, :password))

        if @note.save
          render :show
        else
          render json: {errors: @note.errors}, status: :bad_request
        end
      end

    end

  end
end
