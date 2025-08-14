import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    width: Screen.width
    height: Screen.height
    color: "#1e1e1e" // Dark Background

    Rectangle {
        width: 400
        height: 300
        color: "#2e2e2e"
        radius: 10
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

            TextField{
                id: password
                echoMode: TextInput.Password
                placeholderText: qsTr("Password")
                width: 300
            }

            Button {
                text: "Login"
                width: 120
                onClick: {
                    login(password.text)
                }
            }
        }
    }
}