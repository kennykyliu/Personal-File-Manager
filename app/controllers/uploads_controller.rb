class UploadsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index]
  before_action :set_upload
  def new
    if current_user.folder.nil?
      current_user.folder = current_user.email
      current_user.save
    end
    @uploads = S3_BUCKET.objects.with_prefix(current_user.folder + '/')
  end

  def create
    # Make an object in your bucket for your upload
    if not params[:file]
        flash.now[:alert] = 'Please select file for upload first'
        @uploads = S3_BUCKET.objects.with_prefix(current_user.folder + '/')
        render :new
        return
    end
    loc = current_user.folder + '/' + params[:file].original_filename
    obj = S3_BUCKET.objects[loc]

    # Upload the file
    obj.write(
      file: params[:file],
      acl: :public_read
    )

    # Create an object for the upload
    @upload = Upload.new(
            url: obj.public_url,
            name: obj.key,
            user_id: current_user,
            path: loc)
    # Save the upload
    if @upload.save
      flash.now[:notice] = 'File is uploaded successfully'
    else
      flash.now[:notice] = 'There was an error'
    end
    @uploads = S3_BUCKET.objects.with_prefix(current_user.folder + '/')
    render :new
  end

  def index
    if current_user.folder.nil?
      current_user.folder = current_user.email
      current_user.save
    end
    @uploads = S3_BUCKET.objects.with_prefix(current_user.folder + '/')
  end

  private
    def set_upload
      @user = User.find(current_user)
      @upload = @user.uploads
    end
end
