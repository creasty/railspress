# coding: utf-8

class OauthController < ApplicationController

  def callback

    destroy false if session[:oauth_data]

    account = request.env['omniauth.auth']
    provider = account[:provider]

    was_created = false

    @oauth = Oauth.find_or_create_by_provider_and_uid provider, account[:uid] do
      was_created = true
    end

    oauth_data = {
      uid:      account[:uid],
      provider: provider,
      name:     account[:info][:name],
      user_id:  @oauth.user.try(&:id),
      email:    "#{provider}.#{account[:uid]}@creasty.com"
    }

    unless @oauth.user.present?
      @user = User.new name: oauth_data[:name], email: oauth_data[:email]

      if @user.save validate: false
        @oauth.update_attributes user_id: @user.id
        oauth_data[:user_id] = @user.id
      end
    end

    case provider
    when 'facebook'

      oauth_data[:image_url] = account[:info][:image].sub '?type=square', '?width=200&height=200'
      avatar_image = open URI.parse(oauth_data[:image_url]) rescue nil

      @oauth.update_attributes(
        token:            account[:credentials][:token],
        token_expires_at: account[:credentials][:expires_at],
        avatar:           avatar_image
      )

    when 'twitter'

      oauth_data[:image_url] = account[:info][:image].sub 'normal', 'bigger'
      avatar_image = open URI.parse(oauth_data[:image_url]) rescue nil

      @oauth.update_attributes(
        token:        account[:credentials][:token],
        token_secret: account[:credentials][:secret],
        avatar:       avatar_image
      )

    end

    session[:oauth_data] = oauth_data
    sign_in @oauth.user, bypass: true

=begin
    if was_created
      redirect_to commenter_path
    else
      redirect_to root_path
    end
=end
  end

  def destroy(redirect = true)
    session[:oauth_data] = nil
    redirect_to root_path if redirect
  end

end
