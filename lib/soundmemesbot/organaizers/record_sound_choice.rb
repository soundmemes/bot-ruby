require 'interactor'

module Organaizers
  class RecordSoundChoice
    include Interactor::Organizer

    organize Interactors::Users::FindOrCreate, Interactors::Sounds::Find, Interactors::Choices::Create
  end
end
