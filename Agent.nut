API_Key <- "pWcm2DFvja7bVs5iAzoflHl7wbeZDd5Tyihft88xuElDUN3N";
Feed_ID <- 1013961316;           //Type your Feed ID
Channel_ID <- "Pulse_Counter";    //Type your Channel ID
Channel_ID_Day <- "KWh_Per_Day";    //Type your Channel ID

device.on("queueddata", function(v) {
  // do something interesting with data..
  // we're just going to log it
    channel2 <- Xively.Channel(Channel_ID_Day);
    channel2.Set(v);
    feed2 <- Xively.Feed(Feed_ID, [channel2]);
    client.Put(feed1);
    server.log("Så har vi logget et døgn ");
});

// When receiving "data" message from the device, 
// run this anomymous function

// API &apikey=313eab2b4ae0b02c4e07cc181512ffae
device.on("EmonCms", function(jsonString) { 
 local request = http.get("http://emoncms.org/input/post.json?json="+jsonString+"&apikey=313eab2b4ae0b02c4e07cc181512ffae");
 local response = request.sendsync();
 server.log("Data : "+jsonString);
 server.log("Response: "+response.body);
});

