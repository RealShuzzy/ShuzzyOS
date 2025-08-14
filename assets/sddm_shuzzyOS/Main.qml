import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

Rectangle {
    width: Screen.width
    height: Screen.height
    color: "#1e1e1e" // Dark Background

    Rectangle {
        width: 400
        height: 300
        color: "#2e2e2e"
        radius: 20
        anchors.centerIn: parent

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Welcome"
                color: "white"
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }

            ComboBox {
                id: session
                arrowIcon: "angle-down.png"
                model: sessionModel
                index: sessionModel.lastIndex
            }

            ComboBox {
                id: username
                arrowIcon: "angle-down.png"
                model: userModel
                index: userModel.lastIndex
            }

            PasswordBox{
                id: password
                width: 300
            }

            Button {
                text: "Login"
                width: 150
                onClicked: {
                    sddm.login(
                        username, 
                        password.text, 
                        sessionModel.get(session.currentIndex).key
                    )
                }
            }

            Text {
                text: "Welcome"+ username + "username.text" + username.text
                color: "white"
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "session"+ session + "session.text" + session.text + "key" + sessionModule.get(session.currentIndex).key + "nokey" + sessionModule.get(session.currentIndex)
                color: "white"
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }

            
        }
    }
}