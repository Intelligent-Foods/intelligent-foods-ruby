module IntelligentFoods
  module Testing
    class Fake::Callback
      def self.default(order_id: SecureRandom.uuid, delivery_date: Date.today,
                       carrier: "DEFAULT_CARRIER",
                       tracking_url: "https://domain.com/track/1234",
                       tracking_code: SecureRandom.uuid)
        {
          id: "92a7b2daa3e94fbaae4569205de19888",
          order_id: order_id,
          reference_id: "string",
          event_type: "SHIPMENT_UPDATED",
          shipment_id: "2d482d56f5af4331985c1da40cfe799e",
          data: {
            id: "c2ee9630ad554a08806554db4cb72ee7",
            menu_id: delivery_date.to_date.beginning_of_week.to_s,
            reference_id: "string",
            custom_1: "string",
            custom_2: "string",
            custom_3: "string",
            ship_to: {
              name: "John Doe",
              company: "string",
              street1: "123 Main St",
              street2: "Apt 2B",
              city: "Springfield",
              state: "NY",
              zip: "19191",
              zip4: "1234",
              email: "johndoe@foo.bar",
              phone: "1231231234",
              delivery_instructions: "Door code 2932",
            },
            delivery_date: delivery_date.to_s,
            items: [
              {
                id: "d89397e1bad49c3b855df4406e5bf0d",
                sku: "MP0001",
                protein_id: "cca8eedc9842ff9a80e06242fe5a68",
                protein_sku: "MP0001",
                quantity: 1,
              },
            ],
            user_id: "string",
            projected_shipments: 0,
            callback_url: "https://www.example.com/callback",
            callback_headers: {
              property1: "string",
              property2: "string",
            },
            status: "ACCEPTED",
            validation_options: {
              skip_temperature_check: false,
              skip_address_check: false,
            },
            error_type: "string",
            error_details: "string",
            shipments: [
              {
                id: "2d482d56f5af4331985c1da40cfe799e",
                menu_id: "2020-04-15",
                order_id: "c2ee9630ad554a08806554db4cb72ee7",
                reference_id: "string",
                ship_to: {
                  name: "John Doe",
                  company: "string",
                  street1: "123 Main St",
                  street2: "Apt 2B",
                  city: "Springfield",
                  state: "NY",
                  zip: "19191",
                  zip4: "1234",
                  email: "johndoe@foo.bar",
                  phone: "1231231234",
                  delivery_instructions: "Door code 2932",
                },
                delivery_date: delivery_date.to_s,
                items: [
                  {
                    id: "d89397e1bad49c3b855df4406e5bf0d",
                    sku: "MP0001",
                    quantity: 1,
                  },
                ],
                status: "CREATED",
                delivery_status: "DELIVERED",
                carrier: carrier,
                shipment_number: 1,
                total_shipments: 2,
                tracking_code: tracking_code,
                tracking_url: tracking_url,
                delivery_status_detail: "arrived_at_destination",
                delivery_status_message: "Left on front porch",
                est_delivery_date: delivery_date.to_s,
              },
            ],
          },
        }
      end
    end
  end
end
