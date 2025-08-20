import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import SddmComponents 2.0

Rectangle {
  id: screen
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
    id: stripe_blur
    anchors.centerIn: parent
    width: parent.width / 3
    height: parent.height
  }

  ShaderEffectSource {
    id: bg_blur
    sourceItem: bg
    sourceRect: Qt.rect(stripe_blur.x, stripe_blur.y, stripe_blur.width, stripe_blur.height)
    live: true
  }

  FastBlur {
    id: blur
    source: bg_blur
    anchors.fill: stripe_blur
    radius: 64
  }

  ColumnLayout {
    width: parent.width / 3
    height: parent.height
    anchors.centerIn: parent
    spacing: 0

    Rectangle {
      Layout.preferredWidth: parent.width
      Layout.preferredHeight: parent.height / 2.5
      color: "transparent"

      Text {
        text: "Clock"
        font.pixelSize: 40
        anchors.centerIn: parent
      }
    }

    Rectangle {
      id: middle_stripe
      Layout.preferredWidth: parent.width
      Layout.preferredHeight: parent.height / 3
      color: "transparent"

      Column {
        width: parent.width / 1.5
        height: parent.height / 2

        spacing: parent.height / 20

        anchors.centerIn: parent

        Row {
          width: parent.width
          height: parent.height / 5
          
          // Username
          TextField {
            id: username
            anchors.centerIn: parent
            width: parent.width / 1.25
            height: parent.height
            text: userModel.lastUser
            placeholderText: "Username"
            placeholderTextColor: "white"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            background : Rectangle {
              color: "#55000000"
              radius: 20
            }
            KeyNavigation.tab: password;
          }
          
        }

        Row {
          width: parent.width
          height: parent.height / 5

          // Password
          TextField {
            id: password
            width: parent.width / 1.25
            height: parent.height
            placeholderText: "Password"
            placeholderTextColor: "white"
            echoMode: TextInput.Password
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            background : Rectangle {
              color: "#55000000"
              radius: 20
            }

            anchors.centerIn: parent

            KeyNavigation.tab: control; KeyNavigation.backtab: username

            Keys.onPressed: function (event) {
              if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                sddm.login(username.text, password.text, sessionIndex)
              }
            }
          }
        }

        Row {
          width: parent.width
          height: parent.height / 5

          Button {
            id: control
            width: parent.width / 3
            height: parent.height
            radius: 20
            
            text: "Login"
            anchors.centerIn: parent

            KeyNavigation.backtab: password

            onClicked: { sddm.login(username.text, password.text, sessionIndex) }
          }
        }
      }
    }

    Item { Layout.fillHeight: true }

    Rectangle {
      Layout.preferredWidth: parent.width
      Layout.preferredHeight: parent.height / 15
      color: "transparent"
    }
  }
}