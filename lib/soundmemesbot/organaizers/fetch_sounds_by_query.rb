require_relative '../interactors/users/find_or_create'
require_relative '../interactors/sounds/fetch'

module Organaizers
  class FetchSoundsByQuery
    include Interactor::Organizer

    organize Interactors::Users::FindOrCreate, Interactors::Sounds::Fetch
  end
end
