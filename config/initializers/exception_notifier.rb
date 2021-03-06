require 'action_controller/metal/request_forgery_protection'

Enki::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[Enki] ",
  :sender_address => [Enki::Config.default[:exception_notifications]],
  :exception_recipients => [Enki::Config.default[:exception_notifications]]
