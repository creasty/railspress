# -*- coding: utf-8 -*-

SimpleNavigation::Configuration.run do |navigation|

  navigation.id_generator = Proc.new { |key| nil }

  navigation.items do |primary|
    navigation.auto_highlight = true
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
      highlights_on: :subpath,
      link: { class: 'icon-edit' } \
    do |sub|
      sub.item :index,
        document_title('post', 'index'),
        admin_posts_path,
        link: { class: 'icon-table' }

      sub.item :new,
        document_title('post', 'new'),
        new_admin_post_path,
        link: { class: 'icon-plus' }
    end

    #  Comments
    #-----------------------------------------------
    primary.item :comments,
      document_title('comment', 'index'),
      admin_comments_path,
      highlights_on: :subpath,
      link: { class: 'icon-comment' } \
    do |sub|
      sub.item :index,
        document_title('comment', 'index'),
        admin_comments_path,
        link: { class: 'icon-table' }

      sub.item :new,
        document_title('comment', 'new'),
        new_admin_comment_path,
        link: { class: 'icon-plus' }
    end

    #  Terms
    #-----------------------------------------------
    primary.item :terms,
      document_title('term', 'index'),
      admin_terms_path,
      highlights_on: :subpath,
      link: { class: 'icon-tag' } \
    do |sub|
      sub.item :index,
        document_title('term', 'index'),
        admin_terms_path,
        link: { class: 'icon-table' }

      sub.item :new,
        document_title('term', 'new'),
        new_admin_term_path,
        link: { class: 'icon-plus' }

      sub.item :index,
        document_title('taxonomy', 'index'),
        admin_taxonomies_path,
        link: { class: 'icon-album' }

      sub.item :new,
        document_title('taxonomy', 'new'),
        new_admin_taxonomy_path,
        link: { class: 'icon-plus' }
    end

    #  Media
    #-----------------------------------------------
    primary.item :media,
      document_title('medium', 'index'),
      admin_media_path,
      highlights_on: :subpath,
      link: { class: 'icon-image' } \
    do |sub|
      sub.item :index,
        document_title('medium', 'index'),
        admin_media_path,
        link: { class: 'icon-table' }

      sub.item :new,
        document_title('medium', 'new'),
        new_admin_medium_path,
        link: { class: 'icon-plus' }
    end

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
