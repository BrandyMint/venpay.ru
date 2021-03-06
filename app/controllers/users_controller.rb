# frozen_string_literal: true

class UsersController < ApplicationController
  layout 'simple'

  before_action :validate_captcha, only: [:create] if Settings.use_captcha

  def new
    render locals: { user: user }
  end

  # rubocop:disable Metrics/AbcSize
  def create
    user.locale = I18n.locale
    user.save!

    auto_login user

    redirect_to admin_root_url(board), notice: t_flash
  rescue ActiveRecord::RecordInvalid => e
    if e.record.errors.details.key?(:email) && e.record.errors.details.dig(:email).first[:error] == :taken
      flash_notice! :you_are_registered
      redirect_to new_password_reset_url(password_reset: { email: e.record.email })
    else
      flash_alert! e.message
      render :new, locals: { user: e.record }
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def validate_captcha
    return unless Rails.env.production?
    return if verify_recaptcha model: user

    Bugsnag.notify 'not valid captcha'
    flash_alert! :invalid_captcha
    render :new, locals: { user: user }
  end

  def permitted_params
    params
      .fetch(:user, {})
      .permit(:email, :name, :password, :locale)
  end

  def user
    @user ||= User.new permitted_params
  end
end
