# coding: utf-8

SimpleNavigation::Configuration.run do |navigation|

  navigation.id_generator = Proc.new { |key| nil }
  navigation.auto_highlight = true

  navigation.items do |primary|
    primary.dom_id = 'sitemenu'

    #  Dashboard
    #-----------------------------------------------
    primary.item :admin,
      document_title('admin', 'index'),
      admin_root_path,
      link: { class: 'icon-dashboard' }

    #  Pages
    #-----------------------------------------------
    primary.item :pages,
      document_title('page', 'index'),
      admin_pages_path,
      highlights_on: :subpath,
      link: { class: 'icon-file' }

    #  Posts
    #-----------------------------------------------
    primary.item :posts,
      document_title('post', 'index'),
      admin_posts_path,
      highlights_on: %r(posts/?(\d+/edit|new|tags)?$),
      link: { class: 'icon-edit' }

    #  Comments
    #-----------------------------------------------
    primary.item :comments,
      document_title('comment', 'inbox'),
      comments_admin_posts_path,
      highlights_on: :subpath,
      link: { class: 'icon-comments' }

    #  Media
    #-----------------------------------------------
    primary.item :media,
      document_title('medium', 'index'),
      admin_media_path,
      highlights_on: :subpath,
      link: { class: 'icon-image' }

    #  Users
    #-----------------------------------------------
    primary.item :users,
      document_title('user', 'index'),
      admin_users_path,
      highlights_on: :subpath,
      link: { class: 'icon-group' }

  end

end
