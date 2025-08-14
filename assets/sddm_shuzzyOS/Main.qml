import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

import "components"

Rectangle {
  width: Screen.width
  height: Screen.height
  color: "#1e1e1e" // Dark Background

  Rectangle {
    width: 500
    height: 500
    color: "#2e2e2e"
    radius: 20
    anchors.centerIn: parent

    Column {
      anchors.centerIn: parent
      spacing: 20

      LoginForm {
        id: form
        height: 300
        width: 300
      }

      Button {
        onClicked: {
          sddm.login("shuzzy","shuzzy","hyprland")
        }
      }
    }
  }
}