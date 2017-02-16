require 'bunny'
# require 'pry'
# require 'byebug'

class Subscriber
  def self.subscribe_and_create_jobs
    connection = Bunny.new(
                            :host => "experiments.turing.io",
                            :port => "5672",
                            :user => "student",
                            :pass => "PLDa{g7t4Fy@47H"
                            )
    connection.start
    channel = connection.create_channel
    queue = channel.queue("scrapers.to.lookingfor")

    queue.subscribe do |delivery_info, metadata, payload|
      parsed = JSON.parse(payload, symbolize_names: true)
      Job.create!(title: parsed[:title],
                  description: parsed[:description],
                  url: parsed[:url],
                  posted_date: parsed[:posted_date],
                  )
    end
  end

end

# {"id":"38173a4a-dbcc-11e6-9c53-e2c21bd61de8","title":"Development Engineer - Working in Japan","description":"<p><strong>Both Japanese speakers and Non-Japanese speakers welcomed (if working in Fukuoka)</strong>; there are many English speakers working with the company. Successful applicants without Japanese language skills may be asked to attend a Japanese training course for half of every working day for at least 3 months ~ 12 months after arriving in Fukuoka. This training is paid for by the employer, and is an excellent chance to pick up new language skills.</p>\n\n<p><strong>Choose your work location depending on your Japanese language skills!</strong></p>\n\n<ul>\n<li><strong>No Japanese skills</strong>: Assigned to <strong>Fukuoka office</strong>. However, those wishing to transfer to Tokyo office may do so after attaining basic conversational skills if desired.</li>\n<li><strong>Japanese skills</strong> equivalent to <strong>JLPT Level 2 or above</strong>: Choose between <strong>Tokyo or Fukuoka office</strong></li>\n</ul>\n\n<p>Many of the world&#39;s best engineers work with the company, and approximately 30% of them hail from overseas. Experienced IT engineers who can put the user&#39;s perspective first and wish to make a positive impact on the tens of millions of daily users are encouraged to apply!</p>\n\n<p><strong>Job Description:</strong>\nSuccessful candidates will be assigned as a server-side or app developer based on their previous work experience, as well as their career wishes. Regardless of their actual position, developers are able and encouraged to take part in all of the production process, from planning to implementation.</p>\n\n<p><strong>Specific duties will include :</strong></p>\n\n<ul>\n<li>Development of smartphone applications for the company and clients</li>\n<li>Server development for the company&#39;s smartphone applications</li>\n<li>Researching of new technology, followed by test development and information sharing</li>\n<li>Implementation of strategies for service quality maintenance and performance improvement</li>\n</ul>\n\n<p><strong>Job Requirements:</strong></p>\n\n<ul>\n<li><strong>English language skills (business level or above)</strong></li>\n<li>Non Japanese speaking applicants must be <strong>willing to learn the Japanese language</strong> after arriving Japan</li>\n<li><strong>Professional knowledge of at least one programming language</strong></li>\n<li>Understanding of computer science</li>\n<li>Fundamental knowledge of <strong>memory, processes, threads, and their relation to programming</strong></li>\n<li>A fundamental understanding of <strong>network technology (e.g. TCP/UDP, HTTP, etc.), databases, and SQL</strong></li>\n</ul>\n\n<p><strong>Preferred Skills:</strong></p>\n\n<ul>\n<li>Experience in developing native apps using <strong>Java/Objective-C</strong></li>\n<li>Experience in Web application development using languages such as <strong>Java, PHP, Perl, Ruby, Python, etc.</strong></li>\n<li>A history of active participation in the Open Source community</li>\n<li><strong>Experience with development/operation of systems with large quantities of data and traffic</strong></li>\n</ul>\n\n<p><strong>Working hours:</strong>\n<strong>Discretionary and flexible</strong> according to abilities and speed of task completion; if all tasks and projects are completed well and on time, you do not need to stay in the office for extended periods of time.</p>\n\n<p><strong>Salary:</strong>\n<em>Minimum 6 million Japanese Yen per annual</em> (higher compensation will be provided based on skills and experience and is negotiable). We also offer <strong>relocation allowance</strong> to the right candidate.</p>\n\n<p><strong><Please note></strong>\n<strong>※You are welcome to reapply for this position within the group again\nafter a period of 12 months has passed.</strong></p>\n","url":"http://jobs.github.com/positions/38173a4a-dbcc-11e6-9c53-e2c21bd61de8","location":"Fukuoka,Japan","posted_date":"Mon Jan 16 10:33:59 UTC 2017","company_name":"LINE"}
