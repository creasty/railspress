
module Paperclip

  class Cropper < Thumbnail

    def transformation_command
      target = @attachment.instance

      if target.cropping?
        crop_command = ["-crop", "\"#{target.crop_w.to_i}x#{target.crop_h.to_i}+#{target.crop_x.to_i}+#{target.crop_y.to_i}\""]
        super << crop_command
      else
        super
      end

    end

  end

end
