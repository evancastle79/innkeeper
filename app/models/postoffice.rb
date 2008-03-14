class Postoffice < ActionMailer::Base

  # make note of the headers, content type, and time sent
  # these help prevent your email from being flagged as spam

  def welcome(name, email)
    @recipients   = "webmaster@pakalanainn.com"
    @from         = "webmaster@pakalanainn.com" # params[:contact][:email]
    @headers      = {"Reply-to" => "robot-noreply@pakalanainn.com"}
    @subject      = "Pakalana Inn - You'll be notified"
    @sent_on      = Time.now
    @content_type = "text/html"
    @charset      = "ISO-8859-1"
    
    body[:name]  = name
    body[:email] = email
  end
  
end
