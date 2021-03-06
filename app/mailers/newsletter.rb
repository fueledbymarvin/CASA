class Newsletter < ActionMailer::Base
  default from: "yale.casa@gmail.com", css: "email"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.newsletter.weekly.subject
  #
  def weekly(events, message, date, addendum)
    @events = events
    @message = message

    subject = addendum ? "CASA Newsletter Addendum" : "CASA Weekly Newsletter"
    
    mail to: "casa-list@mailman.yale.edu", subject: "#{subject}: #{date.strftime("%B %e, %Y")}"
  end
end
