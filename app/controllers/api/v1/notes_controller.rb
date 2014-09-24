
module Api
  module V1

    class NotesController < ApplicationController
      respond_to :json
      
      rescue_from ActionController::ParameterMissing do |exception|
        bad_request(exception)
      end
      
      rescue_from ArgumentError do |exception|
        bad_request(exception)
      end

      rescue_from ActiveRecord::RecordNotFound do
        respond_with errors: 'not_found', status: :not_found
      end

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

      def bad_request(exception = nil)
        render json: {errors: (exception ? exception.message : 'bad request')}, status: :bad_request
      end

    end

  end
end
