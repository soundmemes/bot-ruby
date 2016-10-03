require_relative '../interactors/users/find_or_create'
require_relative '../interactors/sounds/find'
require_relative '../interactors/sounds/save'

module Organaizers
  class SaveSound
    include Interactor::Organizer

    organize Interactors::Users::FindOrCreate, Interactors::Sounds::Find, Interactors::Sounds::Save
  end
end
