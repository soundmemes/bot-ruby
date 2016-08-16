require 'interactor'

module Organaizers
  class SaveSound
    include Interactor::Organizer

    organize Interactors::Users::FindOrCreate, Interactors::Sounds::Find, Interactors::Sounds::Save
  end
end
