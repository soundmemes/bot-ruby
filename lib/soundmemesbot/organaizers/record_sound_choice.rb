require_relative '../interactors/users/find_or_create'
require_relative '../interactors/sounds/find'
require_relative '../interactors/choices/create'

module Organaizers
  class RecordSoundChoice
    include Interactor::Organizer

    organize Interactors::Users::FindOrCreate, Interactors::Sounds::Find, Interactors::Choices::Create
  end
end
