require File.dirname(__FILE__) + '/../test_helper'
require 'notifications'

class NotificationsTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end

  def test_travel
    @expected.subject = 'Notifications#travel'
    @expected.body    = read_fixture('travel')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_travel(@expected.date).encoded
  end

  def test_purchase
    @expected.subject = 'Notifications#purchase'
    @expected.body    = read_fixture('purchase')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_purchase(@expected.date).encoded
  end

  def test_expense_claim
    @expected.subject = 'Notifications#expense_claim'
    @expected.body    = read_fixture('expense_claim')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_expense_claim(@expected.date).encoded
  end

  def test_freight
    @expected.subject = 'Notifications#freight'
    @expected.body    = read_fixture('freight')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_freight(@expected.date).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/notifications/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
