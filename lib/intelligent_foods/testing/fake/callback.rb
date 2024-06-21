module IntelligentFoods
  module Testing
    class Fake::Callback
      def self.shipment_created(order_id: SecureRandom.uuid,
                                shipment_id: SecureRandom.uuid,
                                delivery_date: Date.today,
                                carrier: "DEFAULT_CARRIER",
                                tracking_url: "https://domain.com/track/1234",
                                tracking_code: SecureRandom.uuid)
        {
          id: shipment_id,
          order_id: order_id,
          reference_id: SecureRandom.uuid,
          event_type: "SHIPMENT_CREATED",
          shipment_id: shipment_id,
          data: {
            id: shipment_id,
            menu_id: delivery_date.to_date.beginning_of_week.to_s,
            order_id: order_id,
            reference_id: SecureRandom.uuid,
            ship_to: {
              name: "Full Name",
              company: "Company Name",
              street1: "123 Main Street",
              street2: "",
              city: "Gotham",
              state: "NY",
              zip: "12345",
              zip4: "",
              email: "example@domain.com",
              phone: "5555555555",
              delivery_instructions: "Default delivery instructions",
            },
            delivery_date: delivery_date,
            items: [
              {
                id: "d89397e1bad49c3b855df4406e5bf0d",
                sku: "MP0001",
                protein_id: "cca8eedc9842ff9a80e06242fe5a68",
                protein_sku: "MP0001",
                quantity: 1,
              },
            ],
            status: "CREATED",
            delivery_status: "CREATED",
            carrier: carrier,
            shipment_number: 1,
            total_shipments: 1,
            tracking_code: tracking_code,
            tracking_url: tracking_url,
            delivery_status_detail: "arrived_at_destination",
            delivery_status_message: "Left on front porch",
            est_delivery_date: delivery_date.to_s,
          },
        }
      end
    end
  end
end
