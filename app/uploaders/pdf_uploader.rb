class PdfUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.class.to_s.underscore}/pdf"
  end

  def extension_whitelist
    %w[pdf]
  end

  def filename
    return if original_filename.nil? # 没有原始文件时，也就是非上传的情况

    @md5_name ||= Digest::MD5.hexdigest(current_path)
    "#{@md5_name}.#{file.extension.downcase}"
  end
end
