# coding: utf-8

class NotificationMailer < ActionMailer::Base

  extend ApplicationHelper

  layout 'email'

  default from: ENV['MAIL_NOREPLY']

  #  コメントが投稿されたとき、管理者に送信する通知メール
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

  #  誰かが誰かに返信したときに送信する通知メール
  #-----------------------------------------------
  def reply(replied_user, user, comment)
    @user = replied_user
    @replying_user = user
    @commentable = comment.commentable
    @comment = comment

    subject = I18n.t(
      'notification_mailer.reply.subject',
      username: @replying_user.username
    )

    mail to: @user.email, subject: subject
  end

  #  アカウントが削除されたとき送信する通知メール
  #-----------------------------------------------
  def cancel_account(user)
    @user = user

    mail to: @user.email,
      subject: I18n.t('notification_mailer.cancel_account.subject')
  end

  def news(user)
    @user = user

    mail to: @user.email
  end


  def self.deliver_mail(mail)
    allow_send = true # production 以外では @creasty.com にしか送信しない
    unless Rails.env.production?
      mail.to.each do |to|
        unless to =~ /@creasty\.com$/
          allow_send = false
          break
        end
      end
    end
    if allow_send
      ActiveSupport::Notifications.instrument('deliver.action_mailer') do |payload|
        set_payload_for_mail(payload, mail)
        yield # Let mail do the delivery actions
      end
    else
      raise 'Cannot deliver to this email address.'
    end
  end

end
