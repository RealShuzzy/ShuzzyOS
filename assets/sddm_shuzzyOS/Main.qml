import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import SddmComponents 2.0

Rectangle {
  width: Screen.width
  height: Screen.height
  color: "#0f0f0f"

  property int sessionIndex: session.index

  TextConstants { id: textConstants}

  Connections {
    target: sddm
    function onLoginSucceeded() {}
    function onInformationMessage(Message) {}
    function onLoginFailed() {
      pw_entry.text = ""
    }
  }
  
  Background {
    id: bg
    anchors.fill: parent
    source: Qt.resolvedUrl(config.background)
    fillMode: Image.PreserveAspectCrop
  }

  Rectangle {
    id: blurMask
    anchors.centerIn: parent
    width: 500
    height: parent.height
  }

  ShaderEffectSource {
    id: croppedBg
    sourceItem: bg
    sourceRect: Qt.rect(blurMask.x, blurMask.y, blurMask.width, blurMask.height)
    live: true
  }

  FastBlur {
    id: blur
    source: croppedBg
    anchors.fill: blurMask
    radius: 64
  }

  Rectangle {
    width: 500
    height: 300
    color: "#88000000"
    anchors.centerIn: parent

    Item {
      anchors.centerIn: parent

      Text {
        text: sddm.hostName
      }

      Column {
        Row {
          TextBox {
            id: user_entry
            text: userModel.lastUser
          }
        }

        Row {
          PasswordBox {
            id: pw_entry

            Keys.onPressed: function (event) {
              if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                sddm.login(user_entry.text, pw_entry.text, sessionIndex)
              }
            }
          }
        }
      }
    }
  }
}