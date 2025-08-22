import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import SddmComponents 2.0 as SDDM

Rectangle {
  property int currentSession: sessionModel.lastIndex

  id: screen
  width: Screen.width
  height: Screen.height
  color: "#0f0f0f"

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
    anchors.fill: stripe_blur
    source: bg_blur
    radius: 64
  }
  
  // Menu controls
  Keys.onPressed: function (event) {
    if (event.key === Qt.Key_Escape) {
      if (poweroff.activeFocus) {
        reboot.forceActiveFocus()
      } else if (reboot.activeFocus) {
        suspend.forceActiveFocus()
      } else if (suspend.activeFocus) {
        session.forceActiveFocus()
      } else if (session.activeFocus) {
        if (sessionList.visible) {
          sessionList.visible = false
        } else {
          keyboard.forceActiveFocus()
        }
      } else if (keyboard.activeFocus) {
        poweroff.forceActiveFocus()
      } else {
        poweroff.forceActiveFocus()
      }
    }
  }

  // Middle stripe
  ColumnLayout {
    anchors.centerIn: parent
    width: parent.width / 3
    height: parent.height
    
    // Clock and Date
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

          // Clock
          Row {
            width: parent.width
            height: parent.height / 1.75

            Text {
              id: clock
              anchors.centerIn: parent
              color: "white"
              text: Qt.formatTime(new Date(), "HH:mm")
              font.family: "FiraCode Nerd Font"
              font.pixelSize: 80
              
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

          // Date
          Row {
            width: parent.width
            height: parent.height / 10
            
            Text {
              id: date
              anchors.centerIn: parent
              color: "white"
              text: Qt.formatDate(new Date(), "dddd d")
              font.family: "FiraCode Nerd Font"
              font.pixelSize: 40

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

    // Login form
    Rectangle {
      id: middle_stripe
      Layout.preferredWidth: parent.width
      Layout.preferredHeight: parent.height / 3
      color: "transparent"

      Column {
        anchors.centerIn: parent
        width: parent.width / 1.5
        height: parent.height / 2
        spacing: parent.height / 20

        // Username
        Row {
          width: parent.width
          height: parent.height / 5

          QQC.TextField {
            id: username
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            width: parent.width / 1.25
            height: parent.height
            color: "white"
            background : Rectangle {
              color: "#55000000"
              radius: 20
            }
            text: userModel.lastUser
            placeholderText: "Username"
            placeholderTextColor: "#cccccc"
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 15

            KeyNavigation.tab: password; KeyNavigation.backtab: login

            Keys.onPressed: function (event) {
              if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                password.forceActiveFocus()
              }
            }
          }
        }

        // Password
        Row {
          width: parent.width
          height: parent.height / 5

          QQC.TextField {
            id: password
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            width: parent.width / 1.25
            height: parent.height
            color: "white"
            background : Rectangle {
              color: "#55000000"
              radius: 20
            }
            echoMode: TextInput.Password
            placeholderText: "Password"
            placeholderTextColor: "#cccccc"
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 15

            KeyNavigation.tab: login; KeyNavigation.backtab: username

            Keys.onPressed: function (event) {
              if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                sddm.login(username.text, password.text, currentSession)
              }
            }
          }
        }

        // Login button
        Row {
          width: parent.width
          height: parent.height / 5

          QQC.Button {
            id: login
            anchors.centerIn: parent
            width: parent.width / 2.5
            height: parent.height
            background: Rectangle {
              color: login.pressed ? "#88000000" : login.focus ? "#88000000" : login.hovered? "#88000000" : "#55000000"
              radius: 20
            }
            text: "Login"
            font.family: "FiraCode Nerd Font"
            contentItem: Text {
              text: login.text
              color: "white"
              font.pixelSize: 15
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
            }
            onClicked: { sddm.login(username.text, password.text, currentSession) }
            
            KeyNavigation.tab: username; KeyNavigation.backtab: password

            Keys.onPressed: function (event) {
              if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                sddm.login(username.text, password.text, currentSession)
              }
            }
          }
        }
      }
    }

    Item { 
      Layout.fillHeight: true 
      Layout.fillWidth: true

      Rectangle {
        id: sessionList
        anchors.centerIn: parent
        width: parent.width / 3 + 40
        height: sessionModel.count * 30
        radius: 20
        color: "#55000000"
        visible: false

        Column {
          anchors.fill: parent
          Repeater {
            id: repSession
            model: sessionModel
            delegate: Rectangle {
              id: sessionItem
              width: parent.width
              height: 30
              color: sessionList_ma.containsMouse || sessionList_text.focus ? "#88000000" : "transparent"
              radius: 20
              focus: true
              Keys.enabled: true

              Keys.onPressed: (event) => {
                  if (event.key === Qt.Key_Up) {
                      if (currentSession > 0) {
                        currentSession -= 1
                        repSession.itemAt(currentSession).focusMethod()
                      }
                      event.accepted = true
                  } else if (event.key === Qt.Key_Down) {
                      if (currentSession < sessionModel.count - 1) {
                        currentSession += 1
                        repSession.itemAt(currentSession).focusMethod()
                      }
                      event.accepted = true
                  } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                      currentSession = index
                      sessionList.visible = false
                      event.accepted = true
                  }
              }

              function focusMethod() {
                  sessionItem.forceActiveFocus()
              }

              Text {
                  id: sessionList_text
                  text: model.name
                  color: sessionItem.focus ? "green" : "white"
                  font.pixelSize: 15
                  anchors.centerIn: parent
                  font.family: "FiraCode Nerd Font"
              }

              MouseArea {
                  id: sessionList_ma
                  anchors.fill: parent
                  onClicked: {
                      currentSession = index
                      sessionList.visible = false
                  }
              }
          }
          }
        }
      }

    }

    // Menu bar
    Rectangle {
      property bool hovered: false

      id: menu_trigger
      Layout.preferredWidth: parent.width
      Layout.preferredHeight: parent.height / 15
      color: "transparent"

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
          property int iconSize

          id: settingsBar
          width: childrenRect.width + 20
          height: 50
          radius: 20
          color: "#55000000"
          anchors.centerIn: parent
          y: parent.height
          iconSize: 25
          
          Row {
            anchors.centerIn: parent
            spacing: 10

            // poweroff
            Rectangle {
              id: poweroff
              width: 40
              height: 40
              radius: 15
              color: (poweroff_ma.containsMouse || activeFocus) ? "#33000000" : "transparent"

              Image {
                source: "icons/poweroff.svg"
                width: settingsBar.iconSize
                height: settingsBar.iconSize
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

              Keys.onPressed: function (event) {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                  sddm.powerOff()
                }
              }
            }

            // reboot
            Rectangle {
              id: reboot
              width: 40
              height: 40
              radius: 15
              color: (reboot_ma.containsMouse || activeFocus) ? "#33000000" : "transparent"

              Image {
                source: "icons/reboot.svg"
                width: settingsBar.iconSize
                height: settingsBar.iconSize
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

              Keys.onPressed: function (event) {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                  sddm.reboot()
                }
              }
            }

            // Suspend
            Rectangle {
              id: suspend
              width: 40
              height: 40
              radius: 15
              color: (suspend_ma.containsMouse || activeFocus) ? "#33000000" : "transparent"

              Image {
                source: "icons/suspend.svg"
                width: settingsBar.iconSize
                height: settingsBar.iconSize
                smooth: true
                anchors.centerIn: parent
              }

              MouseArea {
                id: suspend_ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: console.log("click")
                cursorShape: Qt.PointingHandCursor
              }

              Keys.onPressed: function (event) {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                  sddm.suspend()
                }
              }
            }

            // Session
            Rectangle {
              id: session
              width: 40
              height: 40
              radius: 15
              color: (session_ma.containsMouse || activeFocus) ? "#33000000" : "transparent"

              Image {
                source: "icons/session.svg"
                width: settingsBar.iconSize
                height: settingsBar.iconSize
                smooth: true
                anchors.centerIn: parent
              }

              MouseArea {
                id: session_ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sessionList.visible = true
                cursorShape: Qt.PointingHandCursor
              }

              Keys.onPressed: function (event) {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                  sessionList.visible = true
                  console.log("Item at", currentSession, "=", repSession.itemAt(currentSession))
                  repSession.itemAt(currentSession).focusMethod()
                }
              }
            }

            // Keyboard
            Rectangle {
              id: keyboard
              width: 40
              height: 40
              radius: 15
              color: (keyboard_ma.containsMouse || activeFocus) ? "#33000000" : "transparent"

              Image {
                source: "icons/keyboard.svg"
                width: settingsBar.iconSize
                height: settingsBar.iconSize
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
        visible: (menu_trigger.hovered || poweroff.focus || reboot.focus || suspend.focus || session.focus || keyboard.focus) ? true : false
      }
    }
  }

  // Focus at start
  Component.onCompleted: {
    if (username.text === "") {
      username.forceActiveFocus()
    } else {
      password.forceActiveFocus()
    }
  }
}
