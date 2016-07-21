require 'sinatra/base'

class FakeWeWorkJobs < Sinatra::Base
  get '/*' do
    xml_response 200, 'we-work-response.xml'
  end

private

  def xml_response(response_code, file_name)
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
