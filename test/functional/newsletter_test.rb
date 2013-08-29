require 'test_helper'

class NewsletterTest < ActionMailer::TestCase
  test "weekly" do
    mail = Newsletter.weekly
    assert_equal "Weekly", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
