class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_filter :set_notification
  #
  # def set_notification
  #      request.env['exception_notifier.exception_data'] = {"server" => request.env['SERVER_NAME']}
  #      # can be any key-value pairs
  # end
end
