module MagentoAPI
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/sales_order_shipment
  # 100  Requested shipment not exists.
  # 101  Invalid filters given. Details in error message.
  # 102  Invalid data given. Details in error message.
  # 103  Requested order not exists.
  # 104  Requested tracking not exists.
  # 105  Tracking not deleted. Details in error message.
  # list
  # info
  # create
  # addComment
  # addTrack
  # removeTrack
  # getCarriers
  class Shipment < Base
    extend MagentoAPI::Helpers::Crud
    class << self
      undef :update, :destroy

      def create(*args)
        commit("create", *args)
      end

      # sales_order_shipment.addComment
      # Add new comment to shipment
      #
      # Return: boolean
      #
      # Arguments:
      #
      # string shipmentIncrementId - shipment increment id
      # string comment - shipment comment
      # boolean email - send e-mail flag (optional)
      # boolean includeInEmail - include comment in e-mail flag (optional)
      def add_comment(*args)
        commit('addComment', *args)
      end

      # sales_order_shipment.addTrack
      # Add new tracking number
      #
      # Return: int
      #
      # Arguments:
      #
      # string shipmentIncrementId - shipment increment id
      # string carrier - carrier code
      # string title - tracking title
      # string trackNumber - tracking number
      def add_track(*args)
        commit('addTrack', *args)
      end

      # sales_order_shipment.removeTrack
      # Remove tracking number
      #
      # Return: boolean
      #
      # Arguments:
      #
      # string shipmentIncrementId - shipment increment id
      # int trackId - track id
      def remove_track(*args)
        commit('removeTrack', *args)
      end

      # sales_order_shipment.getCarriers
      # Retrieve list of allowed carriers for order
      #
      # Return: array
      #
      # Arguments:
      #
      # string orderIncrementId - order increment id
      def get_carriers(*args)
        commit('getCarriers', *args)
      end

      def find(find_type, options = {})
        filters = {}
        options.each_pair { |k, v| filters[k] = {:eq => v} }
        results = where(filters)

        raise MagentoAPI::ApiError, OpenStruct.new(faultCode: 100, faultString: "Requested shipment not exists.") if results.blank?

        if find_type == :first
          new(commit("info", results.first["increment_id"]))
        else
          results.collect do |s|
            new(commit("info", s["increment_id"]))
          end
        end

      end

      def api_path
        "order_shipment"
      end
    end
  end
end
