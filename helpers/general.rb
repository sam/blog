class Blog
  module Helpers
    module General
      def date_to_string(date)
    	date.strftime("%d %b %Y") unless date.blank?
      end
    
      def error_for?(object, field)
        if request.post? && object.errors.key?(field)
          " error"
        end
      end

      def textilize(s)
      	RedCloth.new(s).to_html
      end
    end
  end
end