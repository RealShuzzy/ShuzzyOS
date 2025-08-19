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
    width: parent.width / 3
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
      Layout.preferredWidth: parent.width
      Layout.preferredHeight: parent.height / 3
      color: "transparent"

      Column {
        width: parent.width / 1.5
        height: parent.height / 2

        spacing: parent.height / 15

        anchors.centerIn: parent

        Row {
          width: parent.width
          height: parent.height / 5

          TextBox {
            id: user_entry
            text: userModel.lastUser

            width: parent.width / 1.25
            height: parent.height
            radius:20
            anchors.centerIn: parent

            color: "#55000000"
            borderColor: "transparent"

            KeyNavigation.tab: pw_entry
          }
        }

        Row {
          width: parent.width
          height: parent.height / 5

          PasswordBox {
            id: pw_entry

            width: parent.width / 1.25
            height: parent.height
            radius: 20
            anchors.centerIn: parent

            color: "#55000000"
            borderColor: "transparent"

            KeyNavigation.tab: loginButton; KeyNavigation.backtab: user_entry

            Keys.onPressed: function (event) {
              if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                sddm.login(user_entry.text, pw_entry.text, sessionIndex)
              }
            }
          }
        }

        Row {
          width: parent.width
          height: parent.height / 5

          Button {
            id: loginButton
            width: parent.width / 3
            height: parent.height
            radius: 20
            color: control.down ? "#666" : control.hovered ? "#999" : "#444"

            text: "Login"
            anchors.centerIn: parent

            KeyNavigation.backtab: pw_entry

            onClicked: { sddm.login(user_entry.text, pw_entry.text, sessionIndex) }
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