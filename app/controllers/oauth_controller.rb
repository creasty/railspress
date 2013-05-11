# coding: utf-8

class OauthController < ApplicationController

  def callback

    account = request.env['omniauth.auth']

    oauth_data = {
      uid:      account[:uid],
      provider: account[:provider],
      name:     account[:info][:name]
    }

    # ログインの場合、session を削除
    destroy false if session[:oauth_data]

    oauth = Oauth.find_or_create_by_provider_and_uid account[:provider], account[:uid]

    unless oauth.user.present?
      @user = User.new nickname: oauth_data[:name]
      oauth.update_attributes user_id: @user.id if @user.save validate: false
    end

    defalt_avatar_path = URI.parse 'https://d1cyqrzrnzp5gp.cloudfront.net/common/images/default_avatar.jpg'

    case account[:provider]
    when 'facebook'

      if is_silhouette?(account)
        avatar_image = open(defalt_avatar_path)
      else
        oauth_data[:image_url] = account[:info][:image].sub('?type=square', '?width=200&height=200')
        avatar_image = open(URI.parse(oauth_data[:image_url])) rescue open(defalt_avatar_path)
      end

      oauth.update_attributes(
        :token            => account[:credentials][:token],
        :token_expires_at => account[:credentials][:expires_at],
        :avatar => avatar_image
      )

    when 'twitter'

      if is_default_profile_images?(account)
        avatar_image = open(defalt_avatar_path)
      else
        oauth_data[:image_url] = account[:info][:image].sub('normal', 'bigger')
        avatar_image = open(URI.parse(oauth_data[:image_url])) rescue open(defalt_avatar_path)
      end

      oauth.update_attributes(
        :token        => account[:credentials][:token],
        :token_secret => account[:credentials][:secret],
        :avatar => avatar_image
      )

    end

    session[:oauth_data] = oauth_data

    # redirect_to new_entry_path
  end

  def destroy(redirect = true)
    session[:oauth_data] = nil
    session[:entry_id] = nil
    redirect_to root_path if redirect
  end

  def is_silhouette? omniauth
    graph = Koala::Facebook::API.new(omniauth[:credentials][:token])
    picture = graph.get_connections(omniauth[:uid], 'picture?redirect=false')
    if picture['data'].present? && picture['data']['is_silhouette']
      picture['data']['is_silhouette']
    else
      false
    end
  end

  def is_default_profile_images? omniauth
    omniauth[:info][:image].include?("http://a0.twimg.com/sticky/default_profile_images").presence || false
  end

end