require 'interactor'
require 'open-uri'
require_relative '../../../utils/time_helpers'

module Interactors
  module Sounds
    class Create
      include Interactor

      # Creates a sound from given params
      #
      # @params
      #   user [User]
      #   file_id [String] A Telegram File ID
      #   mime_type [String]
      #   title [String]
      #   tags [String] (Optional) Comma-separated list of tags
      #
      # @return
      #   sound [Sound]
      #   tags [Array<Tag>]
      #   file [File] A file that should be send to retreive a new telegram's file_id
      #   file_size [Integer] A size of newwly created file in bytes
      #   replace_file_id [Boolean] Whether does this sound needs its file_id to be replaced with a new one
      #

      def call
        context.replace_file_id = case context.mime_type
        when %r{audio/.*} # Audio
          bot.api.send_chat_action(
            chat_id: context.telegram_user.id,
            action: 'upload_audio'
          )
          context.file = file_id_to_converted_file(context.file_id)
          true
        else
          raise InvalidMimeTypeError
        end

        context.sound = Sound.create(
          uploader: context.user,
          title: context.title,
        )

        context.tags = context.tags&.gsub(/,([^\s])/, ", #{ $1 }")&.split(', ')&.map do |tag_content|
          tag = Tag.find_or_create(content: tag_content)
          context.sound.add_tag(tag)
        end

        context.sound.save_changes

      rescue InvalidMimeTypeError
        context.fail!(error: :invalid_mime_type)

      rescue ConversionError
        context.fail!(error: :conversion_error)

      end

      def file_id_to_converted_file(file_id)
        input = file_id_to_file(file_id)
        converted_path = convert_to_ogg(input.path)
        File.delete(input.path)
        File.open(converted_path)
      end

      # Loads a file from telegram servers to a tempfile
      #
      def file_id_to_file(file_id)
        telegram_file_path = bot.api.get_file(file_id: file_id)["result"]["file_path"]
        telegram_file_uri = "https://api.telegram.org/file/bot#{ ENV['BOT_API_TOKEN'] }/#{ telegram_file_path }"
        file_from_uri(telegram_file_uri)
      end

      # Converts any file to .ogg with OPUS
      #
      def convert_to_ogg(input_file_path)
        output_path = input_file_path + '.ogg'
        $logger.info("Starting conversion of #{ input_file_path } (#{ (File.size(input_file_path).to_f / 10 ** 3).round(1) } kB)")
        started_at = Time.now
        `ffmpeg -v quiet -t #{ Settings::MAX_SOUND_DURATION } -i #{ input_file_path } -ar 48000 -ac 1 -acodec libopus -ab 128k #{ output_path }`
        raise ConversionError unless File.size(output_path) > 0
        $logger.info("Converted to #{ output_path } (#{ (File.size(output_path).to_f / 10 ** 3).round(1) } kB) in #{ Utils::TimeHelpers.to_sec(Time.now - started_at) }")
        output_path
      end

      def file_from_uri(uri)
        uri = URI.parse(uri)
        extension = uri.to_s.match(/.+\.(\w+)$/)&.[](1)

        case uri
        when URI::HTTP, URI::HTTPS
          file = Tempfile.new(['sound', ".#{ extension }"])
          file.write open(uri.to_s).read
          file.rewind
          file
        else
          raise "Not a valid HTTP(S) uri!"
        end
      end

      def bot
        @bot ||= Telegram::Bot::Client.new(ENV['BOT_API_TOKEN'])
      end

      class InvalidMimeTypeError < StandardError; end
      class ConversionError < StandardError; end
    end
  end
end
