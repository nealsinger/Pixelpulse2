import QtQuick 2.0

Item {
  id: controlItem
  property bool enabled: false
  property bool continuous: false
  property bool repeat: true
  property bool changingMode: false
  // TODO: should be queried from libsmu / device
  // property real sampleRate: 100000 // presently invalid
  property real sampleRate: 125000/2 // current default
  property real sampleTime: 0.1
  readonly property int sampleCount: sampleTime * sampleRate

  function trigger() {
    if (enabled) {
      session.sampleRate = sampleRate
      session.sampleCount = sampleCount
      session.start(continuous);
      console.log("started");
    }
    else {
     console.log("triggered but not enabled");
   }
  }

  Timer {
    id: timer
    interval: 100
    onTriggered: { trigger() }
  }

  function toggle() {
    if (!enabled) {
      enabled = true;
      trigger();
    } else {
      enabled = false;
      if (continuous || sampleTime > 0.1) {
        session.cancel();
      }
    }
  }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
  }

  Connections {
    target: session
    onFinished: {
      console.log("finished: " + "c: " + continuous + " e: " + enabled + " m: " + changingMode);
      if (!continuous) {
        if (repeat) {
            if (enabled) {
                timer.start();
            } else {
                enabled = false;
            }
        }
      }
      else {
        enabled = false
        if (changingMode) {
            delay(100, toggle);
            changingMode = false;
        }
      }
    }
  }
}
