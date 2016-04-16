require 'sinatra/base'

class FakeAuthenticJobs < Sinatra::Base
  get "/api/" do
    if params[:keywords] == 'ruby'
      json_response 200, 'authentic_jobs_ruby_response.json'
    elsif params[:keywords] == 'rubular'
      json_response 200, 'authentic_jobs_no_results_response.json'
    elsif params[:api_key] == '123'
      json_response 200, 'authentic_jobs_bad_api_key_response.json'
    end
  end

private

  def json_response(response_code, file_name)
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
