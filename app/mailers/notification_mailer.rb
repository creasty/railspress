# coding: utf-8

class NotificationMailer < ActionMailer::Base

  extend ApplicationHelper

  layout 'email'

  default from: ENV['MAIL_NOREPLY']


  #  コメントが投稿されたとき、記事の作成者に送る
  #-----------------------------------------------
  def comment(comment)
    @comment = comment
    @user = @comment.user

    subject = I18n.t(
      'notification_mailer.comment.subject',
      username: @user.username
    )

    mail to: @user.email, subject: subject
  end

  #  誰かが誰かに返信したとき、@ユーザに送る
  #-----------------------------------------------
  def reply(comment, object_user)
    @comment = comment
    @user = comment.user
    @object_user = object_user

    subject = I18n.t(
      'notification_mailer.reply.subject',
      username: @user.username
    )

    mail to: @object_user.email, subject: subject
  end

  #  アカウントが削除されたとき
  #-----------------------------------------------
  def account_delete(user)
    @user = user

    mail to: @user.email,
      subject: I18n.t('notification_mailer.account_delete.subject')
  end

  def news(user)
    @user = user

    mail to: @user.email
  end


  #  送信の制御
  #-----------------------------------------------
  def self.deliver_mail(mail)
    # production 以外では @creasty.com にしか送信しない
    allow_send = Rails.env.production? || mail.to.all? { |to| to =~ /@creasty\.com$/ }

    if allow_send
      ActiveSupport::Notifications.instrument('deliver.action_mailer') do |payload|
        set_payload_for_mail payload, mail
        yield
      end
    else
      raise 'Cannot deliver to this email address.'
    end
  end

end
