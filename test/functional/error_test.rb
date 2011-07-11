require 'test_helper'

class ErrorTest < ActionMailer::TestCase
  test "invalid_order" do
    mail = Error.invalid_order(4)
    assert_equal "Invalid order requested", mail.subject
    assert_equal ["honzik@localhost"], mail.to
    assert_equal ["rails@noreply.com"], mail.from
    assert_match /4/, mail.body.encoded
  end

end
