require "rspec/rails"
require "intelligent_foods/testing/fake"

RSpec.configure do |config|
  config.before(:each) do
    stub_const("IntelligentFoods", IntelligentFoods::Testing::Fake)
  end
end
