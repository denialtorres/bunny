require "bunny"
require "pry"

STDOUT.sync = true

conn = Bunny.new

conn.start


ch = conn.create_channel


# declares a queue on the channel that we have just opened, Consumer applications get messages from queues.
# we declared this queue with "auto_delete" paramater
# basically this means that the quque will be deleted when there are no more processes consuming messages from in
q = ch.queue("bunny.examples.hello_world", :auto_delete => true)

# initiates an exchange. Exchange receive messages that are sent by producers.
# Exchange route messages to queues according to rules calling bindings
# in this particuar example there are no explicity defined bindings.
# The exchange that we use is known as the default exchange and it has implied bindings in all queues
x = ch.default_exchange

# subscribe takes a block that will be called everytime a message arrives
# this will happen in a thread pool, so subscribe does not block the that invokes it
q.subscribe do |delivery_info, metadata, payload|
  puts "Received #{payload}"
end

# "routing key" is one of the message properties
# the default exchange will route the message to a queue that has the same name as the message routing routing_key.
# this is how our message ends up in the "bunny.examples.hello_world" queue 
x.publish("Hello!", :routing_key => q.name)

sleep 1.0

conn.close
