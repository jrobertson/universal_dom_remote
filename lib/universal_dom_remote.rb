#!/usr/bin/env ruby

# file: universal_dom_remote.rb


require 'sps_duplex'


class UniversalDomRemoteException < Exception
end

class UniversalDomRemote < SPSDuplex

  def initialize(debug: false)

    super(host: '127.0.0.1', port: '55000', topic: 'udr', 
                 sub_topic: 'browser', pub_topic: 'controller')

    @debug = debug
    @received = []

  end

  # A helpful method to generate the javascript code necessary for the
  # web browser to communicate with the universal DOM remote
  #
  def javascript()

"
var ws = new WebSocket('ws://127.0.0.1:55000/');
ws.onopen = function() {
  console.log('CONNECT');
  ws.send('subscribe to topic: udr/controller');
};
ws.onclose = function() {
  console.log('DISCONNECT');
};
ws.onmessage = function(event) {

  var a = event.data.split(/: +/,2);
  console.log(a[1]);

  try {
    r = eval(a[1]);
  }
  catch(err) {
    r = err.message;
  }

  ws.send('udr/browser: ' + r);

};
"

  end
  
  # used by the callback routine
  #
  def ontopic(topic, msg)
    
    a = topic.split('/')
    sender = a.pop

    puts "%s: %s" % [sender, msg] if @debug
    @received << msg    

  end

  # send the instruction to the web browser
  #
  def send(s, timeout: 30)

    t = Time.now + timeout
    
    super(s)

    sleep 0.1 until @received.any? or Time.now > t
    raise UniversalDomRemoteException, 'recv::timeout' if Time.now > t

    r = @received.last
    @received = []

    return r
  end
    
end
