class Sound < Sequel::Model(:sounds)
  ##
  # Associations
  #
  plugin :pg_array_associations
  pg_array_to_many :tags, uniq: true
  many_to_one :uploader, class: :User
  one_to_many :choices

  ##
  # Repository functions
  #

  # Finds sounds by query optionally ordered by choices count
  #
  # @params
  #   query [String]
  #   @option [Boolean] :order_by_choices_count (true)
  #
  def self.fetch_by_query(query, order_by_choices_count: true, offset: nil, limit: Settings::MAX_QUERY_RESULTS)
    # Original full query
    #
    # SELECT
    #   sounds.*
    # FROM
    #   sounds
    # LEFT JOIN
    #   choices ON choices.sound_id = sounds.id
    # WHERE
    #   tag_ids @> ARRAY[(
    #     SELECT
    #       id
    #     FROM
    #       tags
    #     WHERE
    #       content ILIKE '%query%' ESCAPE '\'
    #   )]
    #   OR
    #   title ILIKE '%query%' ESCAPE '\'
    # GROUP BY
    #   sounds.id
    # ORDER BY
    #   COUNT(CASE WHEN choices.query ILIKE '%query%' THEN choices.id ELSE NULL END) DESC
    #

    q = Sound.eager(:tags).select_all(:sounds).where("tag_ids && ARRAY(#{ Tag.select(:id).where(Sequel.ilike(:content, "%#{ query }%")).sql })").or(Sequel.ilike(:title, "%#{ query }%"))

    q = q.eager(:choices).association_left_join(:choices).group_by(:sounds__id).order{ count(:choices__id).desc } if order_by_choices_count

    q = q.offset(offset) if offset
    q = q.limit(limit) if limit

    q.all
  end

  # Fetches trending sounds
  #
  # @params
  #   @option [Integer] :time (86400) A period to measure trends (defaults to 24 hours)
  #
  def self.fetch_trending(time: 24 * 60 * 60, offset: nil, limit: Settings::MAX_QUERY_RESULTS)
    q = Sound.eager(:choices).eager(:tags).select_all(:sounds).association_left_join(:choices).where{ choices__created_at >= Time.at(Time.now.to_i - time) }.or(choices__id: nil).group_by(:sounds__id).order{ count(:choices__id).desc }

    q = q.offset(offset) if offset
    q = q.limit(limit) if limit

    q.all
  end
end
