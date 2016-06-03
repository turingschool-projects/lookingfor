require 'logger'
require 'capybara'
require 'capybara/poltergeist'
require 'active_support'
require 'active_support/core_ext'

module LoadScript
  class Job_Endpoints
    attr_reader :host

    def initialize(host= nil)
      Capybara.default_driver = :poltergeist
      @host = host || "http://localhost:3000"
    end

    def logger
      @logger ||= Logger.new("./log/requests.log")
    end

    def session
      @session ||= Capybara::Session.new(:poltergeist)
    end

    def run
      puts "Running 10 iterations for data..."
      10.times do |i|
        puts "Running iteration #{i + 1}..."
        run_action(actions.sample)
      end
    end

    def run_action(name)
      benchmark(name) do
        send(name)
      end
    rescue Capybara::Poltergeist::TimeoutError
      logger.error("Timed out executing Action: #{name}. Will continue.")
    end

    def benchmark(name)
      logger.info "Running action #{name}"
      start = Time.now
      val = yield
      logger.info "Completed #{name} in #{Time.now - start} seconds"
      val
    end

    def actions
      [:browse_index, :view_job]
    end

    def browse_index
      session.visit(host)
    end

    def view_job
      session.visit(host)
      session.all("h4").sample.click_link_or_button("View Listing")
    end

    def view_company_jobs
    end
  end
end
