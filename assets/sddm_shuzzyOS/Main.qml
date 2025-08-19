import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
  width: Screen.width
  height: Screen.height
  color: #0f0f0f

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
    anchors.fill: parent
    source: "/home/shuzzy/pictures/wallpapers/wallpaper.png"
    fillMode: Image.PreserveAspectCrop
  }

  Rectangle {
    color: "transparent"
    anchors.centerIn: parent

    Rectangle {
      width: 500
      height: 300
      color: #1f1f1f
      anchors.centerIn: parent

      Item {
        Text {
          text:sddm.hostName
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
}