class Newsletter < ActionMailer::Base
  default from: "yale.casa@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.newsletter.weekly.subject
  #
  def weekly(events, message, date, addendum)
    @events = events
    @message = message

    subject = addendum ? "CASA Newsletter Addendum" : "CASA Weekly Newsletter"

    mail to: "marvin.qian@yale.edu", subject: "#{subject}: #{date.strftime("%B %e, %Y")}"
  end
end
