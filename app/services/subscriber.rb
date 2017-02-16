require 'bunny'

# Connect to the RabbitMQ Instance
connection = Bunny.new(
  :host => "experiments.turing.io",
  :port => "5672",
  :user => "student",
  :pass => "PLDa{g7t4Fy@47H"
)

connection.start

# Establish a "channel" on that connection
channel = connection.create_channel
