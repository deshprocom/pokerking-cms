class AdminImagesController < ApplicationController
  def create
    @image = AdminImage.new
    @image.image = params[:image]
    if @image.save
      render json: { success: true, msg: 'Upload Success', file_path: @image.image_url }
    else
      render json: { success: false }
    end
  end
end
