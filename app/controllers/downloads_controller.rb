class DownloadsController < ApplicationController
  def new
  end

  def create
    #upload = Upload.find_by(name: params[:name])
    obj = S3_BUCKET.objects[params[:name]]
    File.open(params[:name].split('/')[1], 'wb') do |file|
      obj.read do |chunk|
        file.write(chunk)
      end
    end
    send_file(params[:name].split('/')[1],
      :type => 'application/pdf/docx/html/htm/doc/jpg',
      :disposition => 'attachment') 
  end

  def index
  end
end
