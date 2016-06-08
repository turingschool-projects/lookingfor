config = {
  host: "http://localhost:9200/",
  transport_options: {
    request: { timeout: 500 }
  },
}

if File.exists?("config/elasticsearch.yml")
  config.merge!(YAML.load_file("config/elasticsearch.yml").symbolize_keys)
end

Elasticsearch::Model.client = Elasticsearch::Client.new(config)

# This file will overwrite any previous preferences in a `config/elasticsearch.yml` file that you might have for ES in general
# You should be able to easily hold things like pagination preferences and result returns here
