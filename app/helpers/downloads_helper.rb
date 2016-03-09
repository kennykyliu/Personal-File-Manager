module DownloadsHelper
  def download_file(path, filename)
    obj = S3_BUCKET.objects[path]
    File.open(filename, 'wb') do |file|
      obj.read do |chunk|
        file.write(chunk) 
      end
    end
  end

end
