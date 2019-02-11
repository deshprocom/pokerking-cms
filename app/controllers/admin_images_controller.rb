class AdminImagesController < ApplicationController
  def create
    @image = AdminImage.new
    @image.image = params[:image]
    if @image.save
      render json: { success: true, msg: '上传成功', file_path: @image.image_url }
    else
      render json: { success: false }
    end
  end
end
