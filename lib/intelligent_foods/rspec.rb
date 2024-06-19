require "rspec/rails"
require "intelligent_foods/testing/fake"
require "intelligent_foods/testing/fake/callback"

RSpec.configure do |config|
  config.before(:each) do
    stub_const("IntelligentFoods", IntelligentFoods::Testing::Fake)
  end
end
