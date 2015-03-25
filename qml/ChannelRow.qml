import QtQuick 2.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.1

Rectangle {
  id: channelBlock
  property var channel
  color: '#333'

	function updateMode(m) {
	   var oldMode = channel.mode;
	   channel.mode = m;
	   var chIdx = {A: 1, B: 2}[channel.label];
       if (oldMode != channel.mode)
          console.log("changing " + chIdx + " from " + oldMode + " to " + channel.mode);
	   xyPane.children[2+chIdx].ysignal = (channel.mode == 1) ? xyPane.children[2+chIdx].isignal : xyPane.children[2+chIdx].vsignal;
	   xyPane.children[2+chIdx].xsignal = (channel.mode == 1) ? xyPane.children[2+chIdx].vsignal : xyPane.children[2+chIdx].isignal;
       if ( (controller.continuous) & (oldMode != channel.mode) & (controller.enabled)) {
         controller.changingMode = true;
         controller.toggle();
       }
	}

  Button {
    anchors.top: parent.top
    anchors.left: parent.left
    width: timelinePane.spacing
    height: timelinePane.spacing

    property var icons: [
      'mv',
      'svmi',
      'simv',
    ]
    iconSource: 'qrc:/icons/' + icons[channel.mode] + '.png'

    style: ButtonStyle {
      background: Rectangle {
        opacity: control.pressed ? 0.3 : control.checked ? 0.2 : 0.1
        color: 'black'
      }
    }


    menu: Menu {
      MenuItem { text: "Measure Voltage"
        onTriggered: channelBlock.updateMode(0);
      }
      MenuItem { text: "Source Voltage, Measure Current"
        onTriggered: channelBlock.updateMode(1)
      }
      MenuItem { text: "Source Current, Measure Voltage"
        onTriggered: channelBlock.updateMode(2)
      }
    }
  }


  Text {
    text: "Channel " + channel.label
    color: 'white'
    rotation: -90
    transformOrigin: Item.TopLeft
    font.pixelSize: 18
    y: width + timelinePane.spacing + 8
    x: (timelinePane.spacing - height) / 2
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.leftMargin: timelinePane.spacing
    spacing: 0

    Repeater {
      model: modelData.signals

      SignalRow {
        Layout.fillHeight: true
        Layout.fillWidth: true

        signal: model
        xaxis: timeline_xaxis
      }
    }
  }
}
