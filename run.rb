require 'csv'

require 'bundler'
Bundler.require

mail_options = {
  :address         => "mailtrap.io",
  :port            => 2525,
  :domain          => 'your.host.name',
  :user_name       => ENV['smtp_username'],
  :password        => ENV['smtp_password'],
  :authentication  => 'plain'
}

Mail.defaults do
  delivery_method :smtp, mail_options
end


CSV.foreach('sample.csv', headers: true) do |row|
  #p row
  body = <<-EOS
    Your score results for the bonus period 1Q/2013

    Period Age: #{row["Age"]}

    Age Proportional: #{row["Proportional"]}

    Scores:

    FLPR    (100): #{row["FLPR Score"].to_f.round(2)}
    Bonus   (150): #{row["Bonus Score"].to_f.round(2)}
    English (70):  #{row["English Score"].to_f.round(2)}
    Blog    (30):  #{row["Blog score"].to_f.round(2)}
    Talks   (50):  #{row["Talk score"].to_f.round(2)}
    ================================
    Total score: #{row["Score"].to_f.round(2)}
    Percentile:  #{(row["Bonus %"].to_f * 100).round(4)}

    Base Bonus:   $ #{row["Base"].to_f.round(2)}
    Scored Bonus: $ #{row["NonBase Bonus"].to_f.round(2)}

    Total Bonus:  $ #{row["Total Bonus"].to_f.round(2)}
    EOS

    p "Sending bonus results to #{row["email"]}..."

    mail = Mail.deliver do
      from "comite@crowdint.com"
      to "#{row["email"]}@crowdint.com"
      subject "Bonus Score Results"
      body body
    end
end
