require 'interactor'

module Organaizers
  class FetchSoundsByQuery
    include Interactor::Organizer

    organize Interactors::Users::FindOrCreate, Interactors::Sounds::Fetch
  end
end
