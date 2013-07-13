require 'csv'

require 'bundler'
Bundler.require

CSV.foreach('sample.csv', headers: true) do |row|
  body = <<-EOS
    Score results for the bonus period 1Q/2013

    Period Age: #{row["Age"]}

    Age Proportional: #{row["Proportional"]}

    Scores:

    FLPR: #{row["FLPR Score"]}
    Bonus: #{row["Bonus Score"]}
    English: #{row["English Score"]}
    Blog: #{row["Blog score"]}
    Talk score: #{row["Talk score"]}
    ================================
    Total score: #{row["Score"]}
    Percentile: #{row["Bonus %"]}

    Base Bonus: #{row["Base"]}
    Scored Bonus: #{row["NonBase Bonus"]}

    Total Bonus: #{row["Total Bonus"]}
  EOS

  mail = Mail.deliver do
    from "comite@crowdint.com"
    to "david@crowdint.com"
    subject "Bonus Score Results"
    body body
  end
end
