require 'interactor'

module Organaizers
  class CreateSound
    include Interactor::Organizer

    organize Interactors::Users::FindOrCreate, Interactors::Sounds::Create
  end
end
