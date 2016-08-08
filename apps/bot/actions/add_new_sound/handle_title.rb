module Apps; module Bot
  module Actions
    module AddNewSound
      class HandleTitle
        def call
          (user_state.params[:attributes] ||= {})[:title] = params[:title].to_s
        end
      end
    end
  end
end; end
