module Admin

  module ApplicationHelper

=begin
    def modal(id, &body)
      render 'admin/components/modal', id: id, body: capture(&body)
    end
=end

    def image_preloader(src, options = {})
      options[:data] ||= {}
      options[:data][:src] = src

      # data:image/gif;base64,R0lGODlhAQABAID/AMDAwAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==
      image_tag 'admin/common/preloader.gif', options
    end

  end

end