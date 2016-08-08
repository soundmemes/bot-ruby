module Utils
  module URLBuilder
    def self.build(options = {})
      path = options[:path]
      secure = options.fetch(:secure, !!ENV['DOKKU_NGINX_SSL_PORT'])

      result = "http#{ secure ? 's' : nil }://#{ ENV['WEB_HOST'] }"
      result += path if path
    end
  end
end
