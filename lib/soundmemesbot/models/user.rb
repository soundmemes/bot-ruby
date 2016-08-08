require 'attribute_enum'

class User < Sequel::Model(:users)
  include AttributeEnum
  enum :status, %i(active blocked banned)

  alias_method :admin?, :admin

  ##
  # Associations
  #

  one_to_many :tags
  one_to_many :sounds
  one_to_many :choices

  ##
  # Telegram
  #

  def self.find_by_telegram_id(telegram_id)
    where(telegram_id: telegram_id).first
  end
end
