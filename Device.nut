// Læser Pulser på Emernet E420
// 10.000 pulser/kwh
// Dong El Pris gælder 1. kvt 2014 228,04 øre

queue <- [];
count <- hardware.pin1;
count.configure(PULSE_COUNTER, 20); // Tæller i x sekunder
Frekvens <- 0;
WattHour <-0; 
WattMinut <-0;

const PulsePrKWH = 10000;
const elpris = 228.04

function sendQueuedData() {
        agent.send("queueddata", queue);
        queue = [];
} 
 
function GetApproximateFrequency() {
  local numPulses = count.read();
  local approxFreq = numPulses * 3.0; // ganger med x for at få et minut
  return approxFreq;
}
 
function SendDataToCloud() {
    Frekvens = GetApproximateFrequency() ; 
   
    local t = time();
    queue.push({ timestamp = t, sensorvalue = Frekvens });
 
    // if it is midnight
    if (t % 86400 == 0) {
        sendQueuedData();
    }

    Frekvens = GetApproximateFrequency() ; 
    WattHour = (36000000 / Frekvens) / PulsePrKWH;    //  Antal blink for en KHh 60 x 60 x 10.000
    server.log("The signal on pin1 is about" + Frekvens + "Hz");
    //agent.send("Xively", Frekvens);
    local jsonString="{power:"+Frekvens+",WattHour:"+WattHour+"}"; 
    agent.send("EmonCms",jsonString);     // Sending data to "agent"
    
    
}

imp.onidle(function() {
    SendDataToCloud();
    server.sleepfor(60 - (time() % 60));
});
