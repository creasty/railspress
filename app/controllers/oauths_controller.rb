# coding: utf-8

require 'open-uri'


class OauthsController < ApplicationController

  def callback
    session[:oauth_data] = nil if session[:oauth_data]

    account = request.env['omniauth.auth']
    provider = account[:provider]

    was_created = false

    @oauth = Oauth.find_or_create_by_provider_and_uid provider, account[:uid] { was_created = true }

    oauth_data = {
      uid:      account[:uid],
      provider: provider,
      name:     account[:info][:name],
      email:    "#{provider}.#{account[:uid]}@creasty.com"
    }

    unless @oauth.user.present?
      if user_signed_in? && current_user
        oauth_data[:user_id] = current_user.id
      else
        @user = User.new name: oauth_data[:name], email: oauth_data[:email]

        if @user.save validate: false
          @oauth.update_attributes user_id: @user.id
          oauth_data[:user_id] = @user.id
        end
      end
    end

    case provider
    when 'facebook'

      oauth_data[:image_url] = account[:info][:image].sub '?type=square', '?width=200&height=200'
      avatar_image = open URI.parse(oauth_data[:image_url]) rescue nil

      @oauth.update_attributes(
        user_id:          oauth_data[:user_id],
        token:            account[:credentials][:token],
        token_expires_at: account[:credentials][:expires_at],
        avatar:           avatar_image
      )

    when 'twitter'

      oauth_data[:image_url] = account[:info][:image].sub 'normal', 'bigger'
      avatar_image = open URI.parse(oauth_data[:image_url]) rescue nil

      @oauth.update_attributes(
        user_id:      oauth_data[:user_id],
        token:        account[:credentials][:token],
        token_secret: account[:credentials][:secret],
        avatar:       avatar_image
      )

    end

    session[:oauth_data] = oauth_data
    sign_in @oauth.user, bypass: true unless user_signed_in?
  end

  def destroy
    @oauth = current_user.oauths.find_by_provider params[:provider]
    @oauth.destroy
    session[:oauth_data] = nil
    render nothing: true
  end

end
