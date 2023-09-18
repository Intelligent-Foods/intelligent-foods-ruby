FactoryBot.define do
  factory :recipient, class: "IntelligentFoods::Recipient" do
    name { "First Name" }
    street1 { "123 Main Street" }
    street2 { "Apt 2B" }
    city { "Springfield" }
    state { "NY" }
    zip { "19191" }
    zip4 { "1234" }
    email { "email@domain.com" }
    phone { "5555555555" }
    delivery_instructions { "Door code 1234" }
  end

  factory :menu, class: "IntelligentFoods::Menu" do
    id { Date.today.to_s }
    deadline { Time.now }
    shipping_fee { 9.99 }
    items { create_list :menu_item, 3 }
  end

  factory :menu_item, class: "IntelligentFoods::MenuItem" do
    sequence :id do |n|
      "d89397e1bad49c3b855df4406e5bf0#{n}"
    end
    sequence :sku do |n|
      "MP00#{n}"
    end
    type { "MARKET" }
    sequence :name do |n|
      "Rosemary Maple Sea Salt#{n}"
    end
  end

  factory :order_item, class: "IntelligentFoods::OrderItem" do
    sequence :sku do |n|
      "IF233#{n}"
    end
    sequence :protein_sku do |n|
      "IF829#{n}"
    end
    quantity { 1 }
  end
end
