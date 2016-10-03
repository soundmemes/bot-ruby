require_relative '../interactors/users/find_or_create'
require_relative '../interactors/sounds/create'

module Organaizers
  class CreateSound
    include Interactor::Organizer

    organize Interactors::Users::FindOrCreate, Interactors::Sounds::Create
  end
end
