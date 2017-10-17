class GlobalID
  module Locator
    private
    class BaseLocator
      def locate(gid)
        model_id = gid.model_id.is_i? ? gid.model_id.to_i : gid.model_id
        gid.model_class.find model_id
      end
    end
  end
end