//圆形按钮
import QtQuick 2.0

Rectangle {
    id: rect
    property alias text: txt.text
    property alias imgSource: img.source
    property alias imgWidth: img.width
    property alias imgHeight: img.height
    property bool isContainsMouse: false
    signal clicked()
    width: radius * 2;
    height: radius * 2;
    Text {
        id: txt
        anchors.centerIn: parent
        font.pixelSize: 30
    }
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked: rect.clicked()
        onContainsMouseChanged: {
            rect.isContainsMouse = containsMouse
            if (rect.isContainsMouse)
                rect.opacity = 0.8
            else
                rect.opacity = 0.2
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration: 500
        }
    }
    Image{
        id: img
        anchors.centerIn: parent
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        width: 0
        height: 0
//        source: "images/播放1.svg"
    }
}

