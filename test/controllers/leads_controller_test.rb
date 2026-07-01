require "test_helper"

class LeadsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get leads_url
    assert_response :success
  end

  test "should get new" do
    get new_lead_url
    assert_response :success
  end

  test "should create lead" do
    assert_difference("Lead.count") do
      post leads_url, params: { lead: { name: 'Test', email: 'test@example.com', message: 'Hello' } }
    end
    assert_redirected_to root_url
  end
end
