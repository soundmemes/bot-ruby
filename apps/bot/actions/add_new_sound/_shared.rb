module Apps; module Bot
  module Actions
    module AddNewSound
      include Shared
      include EasyState

      PHAZES = {
        title: {
          skippable: false
        },
        content: {
          skippable: false
        },
        tags: {
          skippable: true
        }
      }.freeze

      PERMITTED_MIMES = %w(audio/mpeg audio/x-vorbis+ogg audio/x-wav audio/ogg).freeze

      MIN_TITLE_LENGTH = 3.freeze
      COMPLETED = 42.freeze

      def self.get_next_phaze_index(current = nil)
        current_index = current ? PHAZES.keys.find_index(current) : -1
        if current_index >= PHAZES.keys.length - 1
          COMPLETED
        else
          current_index + 1
        end
      end
    end
  end
end; end
