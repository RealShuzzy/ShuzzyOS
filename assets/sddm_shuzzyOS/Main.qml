import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import SddmComponents 2.0 as SDDM



Rectangle {
  

  id: screen
  width: Screen.width
  height: Screen.height
  color: "#0f0f0f"

  property int sessionIndex: session.index

  SDDM.TextConstants { id: textConstants}

  Connections {
    target: sddm
    function onLoginSucceeded() {}
    function onInformationMessage(Message) {}
    function onLoginFailed() {
      pw_entry.text = ""
    }
  }
  
  SDDM.Background {
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
  

  Keys.onPressed: function (event) {
    if (event.key === Qt.Key_Escape) {

      if (poweroff.activeFocus) {
        reboot.forceActiveFocus()
      } else if (reboot.activeFocus) {
        session.forceActiveFocus()
      } else if (session.activeFocus) {
        keyboard.forceActiveFocus()
      } else if (keyboard.activeFocus) {
        poweroff.forceActiveFocus()
      } else {
        poweroff.forceActiveFocus()
      }
    }
  }

  ColumnLayout {
    width: parent.width / 3
    height: parent.height
    anchors.centerIn: parent

    Rectangle {
      Layout.preferredWidth: parent.width
      Layout.preferredHeight: parent.height / 2.5
      color: "transparent"

      Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 100
        width: parent.width
        height: parent.height / 3
        color: "transparent"

        Column {
          width: parent.width
          height: parent.height
          spacing: 20

          Row {
            width: parent.width
            height: parent.height / 1.75
            // Time
            Text {
              id: clock
              font.family: "FiraCode Nerd Font"
              anchors.centerIn: parent
              font.pixelSize: 80
              color: "white"
              text: Qt.formatTime(new Date(), "HH:mm")

              Timer {
                id: clock_timer
                interval: 60000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                  clock.text = Qt.formatTime(new Date(), "HH:mm")
                  var now = new Date()
                  var msUnitlNextMinute = (60 - now.getSeconds()) * 1000
                  clock.Timer.interval = msUnitlNextMinute
                }
              }
            }
          }

          Row {
            width: parent.width
            height: parent.height / 10
            // Date
            Text {
              id: date
              font.family: "FiraCode Nerd Font"
              anchors.centerIn: parent
              font.pixelSize: 40
              color: "white"
              text: Qt.formatDate(new Date(), "dddd d")

              Timer {
                interval: 6000
                running: true
                repeat: true
                onTriggered: date.text = Qt.formatDate(new Date(), "dddd d")
              }
            }
          }
        }
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
          QQC.TextField {
            id: username
            font.family: "FiraCode Nerd Font"
            anchors.centerIn: parent
            width: parent.width / 1.25
            height: parent.height
            text: userModel.lastUser
            placeholderText: "Username"
            placeholderTextColor: "#cccccc"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            background : Rectangle {
              color: "#55000000"
              radius: 20
            }
            
            KeyNavigation.tab: password; KeyNavigation.backtab: login

          }
          
        }

        Row {
          width: parent.width
          height: parent.height / 5

          // Password
          QQC.TextField {
            id: password
            font.family: "FiraCode Nerd Font"
            width: parent.width / 1.25
            height: parent.height
            placeholderText: "Password"
            placeholderTextColor: "#cccccc"
            echoMode: TextInput.Password
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            background : Rectangle {
              color: "#55000000"
              radius: 20
            }

            

            anchors.centerIn: parent

            KeyNavigation.tab: login; KeyNavigation.backtab: username

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

          QQC.Button {
            id: login
            font.family: "FiraCode Nerd Font"
            width: parent.width / 2.5
            height: parent.height
            text: "Login"
            anchors.centerIn: parent
            
            background: Rectangle {
              color: login.pressed ? "#88000000" : login.focus ? "#88000000" : login.hovered? "#88000000" : "#55000000"
              radius: 20
            }

            contentItem: Text {
              text: login.text
              color: "white"
              font.pixelSize: 15
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
            }
            
            KeyNavigation.tab: username; KeyNavigation.backtab: password

            onClicked: { sddm.login(username.text, password.text, sessionIndex) }

            Keys.onPressed: function (event) {
              if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                sddm.login(username.text, password.text, sessionIndex)
              }
            }
          }
        }
      }
    }

    Item { Layout.fillHeight: true }

    Rectangle {
      id: menu_trigger
      Layout.preferredWidth: parent.width
      Layout.preferredHeight: parent.height / 15
      color: "transparent"

      property bool hovered: false
      
      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: menu_trigger.hovered = true
        onExited: menu_trigger.hovered = false
      }

      Item {
        id: menu
        anchors.fill: parent

        Rectangle {
          id: settingsBar
          width: childrenRect.width + 20
          height: 50
          radius: 20
          color: "#55000000"
          anchors.centerIn: parent
          y: parent.height

          
          Row {
            anchors.centerIn: parent
            spacing: 10

            // poweroff
            Rectangle {
              id: poweroff
              width: 40
              height: 40
              radius: 10
              color: (poweroff_ma.containsMouse || activeFocus) ? "#33000000" : "transparent"

              Image {
                source: "icons/poweroff.svg"
                width: 30
                height: 30
                smooth: true
                anchors.centerIn: parent
              }

              MouseArea {
                id: poweroff_ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: console.log("click")
                cursorShape: Qt.PointingHandCursor
              }
            }

            
            // reboot
            Rectangle {
              id: reboot
              width: 40
              height: 40
              radius: 10
              color: (reboot_ma.containsMouse || activeFocus) ? "#33000000" : "transparent"

              Image {
                source: "icons/reboot.svg"
                width: 30
                height: 30
                smooth: true
                anchors.centerIn: parent
              }

              MouseArea {
                id: reboot_ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: console.log("click")
                cursorShape: Qt.PointingHandCursor
              }
            }

            // session
            Rectangle {
              id: session
              width: 40
              height: 40
              radius: 10
              color: (session_ma.containsMouse || activeFocus) ? "#33000000" : "transparent"

              Image {
                source: "icons/session.svg"
                width: 30
                height: 30
                smooth: true
                anchors.centerIn: parent
              }

              MouseArea {
                id: session_ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: console.log("click")
                cursorShape: Qt.PointingHandCursor
              }
            }

            // keyboard
            Rectangle {
              id: keyboard
              width: 40
              height: 40
              radius: 10
              color: (keyboard_ma.containsMouse || activeFocus) ? "#33000000" : "transparent"

              Image {
                source: "icons/keyboard.svg"
                width: 30
                height: 30
                smooth: true
                anchors.centerIn: parent
              }

              MouseArea {
                id: keyboard_ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: console.log("click")
                cursorShape: Qt.PointingHandCursor
              }
            }
          }
        }
        visible: true //menu_trigger.hovered
      }
    }
  }
  Component.onCompleted: {
    if (username.text === "") {
      username.forceActiveFocus = true
    } else {
      password.forceActiveFocus = true
    }
  }
}
