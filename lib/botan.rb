module Botan
  require 'net/http'
  require 'net/https'
  require 'json'

  TRACK_URI_TEMPLATE = 'https://api.botan.io/track?token=%{token}&uid=%{uid}&name=%{name}';
  SHORTENER_URI_TEMPLATE = 'https://api.botan.io/s/?token=%{token}&url=%{original_url}&user_ids=%{uid}'

  def self.track(uid, message, name = 'Message')
    begin
      uri = URI(TRACK_URI_TEMPLATE % { token: ENV["BOTANIO_TOKEN"], uid: uid, name: name })
      $logger.debug("Botan.io: sending tracking info to #{ uri }")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      body = JSON.dump(message)

      req =  Net::HTTP::Post.new(uri)
      req.add_field "Content-type", "application/json"
      req.body = body
      res = http.request(req)
      j = JSON.parse(res.body)

      $logger.debug("Botan.io: successfully tracked!")

      j
    rescue StandardError => e
      $logger.error("Botan.io: HTTP Request failed (#{ e.message })!")
    end
  end

  def self.shorten_url(uid, url)
    uri = URI(SHORTENER_URI_TEMPLATE % { token: ENV['BOTANIO_TOKEN'], uid: uid, original_url: url })
    $logger.debug("Botan.io: shortening #{ url }")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req =  Net::HTTP::Get.new(uri)
    res = http.request(req)

    $logger.debug("Botan.io: Shortened to #{ res.body }")

    res.body
  end
end
