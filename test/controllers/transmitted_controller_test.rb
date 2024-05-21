require "test_helper"

class TransmittedControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get transmitted_index_url
    assert_response :success
  end
end
