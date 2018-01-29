# Introducing the universal_dom_remote gem


## Example

    require 'sps_duplex'

    udr = UniversalDomRemote.new debug: true

    r = udr.send 'console.log("fun");' #=> "undefined" 
    r = udr.send '"1" + "3"'           #=> "13" 
    r = udr.send 'document.title'      #=> "JamesRobertson.eu" 
    r = udr.send 'document.title()'    #=> "document.title is not a function" 

The above exampe was executed from an IRB session.

## Running the example

To run the example you will need:

The SPS broker running:

    require 'simplepubsub

    SimplePubSub::Broker.start port: '55000'

A web browser web console window open with the follow code copied and pasted into it:

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

A debug window with the following code to help troubleshoot message passing:

    require 'sps-sub'

    sps = SPSSub.new host: '127.0.0.1', port: '55000'

    sps.subscribe(topic: '#') do |msg, topic|
      puts "%s: %s " % [topic, msg]
    end

Notes: 

1. JavaScript statements which don't return a value e.g. (console.log) will return the string *undefined*
2. An error message will be returned if a JavaScript statement contains an error
3. The send command will timeout (after 30 seconds by default) if a return statement isn't received within the given time
4. The universal_dom_remote gem was intended to work with any web browser which support websockets. At present the only browser properly tested was Firefox.

## Resources

* universal_dom_remote https://rubygems.org/gems/universal_dom_remote

universal_dom_remote remote control gem javascript browser firefox sps
