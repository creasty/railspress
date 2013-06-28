# coding: utf-8

SimpleNavigation::Configuration.run do |navigation|

  navigation.id_generator = Proc.new { |key| nil }
  navigation.auto_highlight = true

  navigation.items do |primary|
    primary.dom_id = 'globalnav'

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
      link: { class: 'icon-file' } \
    do |sub|
      sub.item :index,
        document_title('page', 'index'),
        admin_pages_path,
        link: { class: 'icon-table' }

      sub.item :new,
        document_title('page', 'new'),
        new_admin_page_path,
        link: { class: 'icon-plus' }
    end

    #  Posts
    #-----------------------------------------------
    primary.item :posts,
      document_title('post', 'index'),
      admin_posts_path,
      highlights_on: %r(posts/?(\d+/edit|new|tags)?$),
      link: { class: 'icon-edit' } \
    do |sub|
      sub.item :index,
        document_title('post', 'index'),
        admin_posts_path,
        link: { class: 'icon-table' }

      sub.item :tags,
        document_title('post', 'tags'),
        tags_admin_posts_path,
        link: { class: 'icon-tag' }

      sub.item :new,
        document_title('post', 'new'),
        new_admin_post_path,
        link: { class: 'icon-plus' }
    end

    #  Comments
    #-----------------------------------------------
    primary.item :comments,
      document_title('comment', 'inbox'),
      comments_admin_posts_path,
      highlights_on: :subpath,
      link: { class: 'icon-comment' }

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
      link: { class: 'icon-group' } \
    do |sub|
      sub.item :index,
        document_title('user', 'index'),
        admin_users_path,
        link: { class: 'icon-table' }

      sub.item :new,
        document_title('user', 'new'),
        new_admin_user_path,
        link: { class: 'icon-plus' }
    end

  end

end
