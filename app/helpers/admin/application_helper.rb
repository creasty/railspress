module Admin
  module ApplicationHelper

    def modal(id, &body)
      render 'admin/components/modal', id: id, body: capture(&body)
    end

    def alert(id, title, style = '', &body)
      render 'admin/components/alert', id: id, title: title, style: style, body: capture(&body)
    end

  end
end