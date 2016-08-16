module Utils
  module ArrayExtensions
    refine Array do
      def promote(value)
        if (found = delete(value))
          unshift(found)
        end

        self
      end
    end
  end
end
