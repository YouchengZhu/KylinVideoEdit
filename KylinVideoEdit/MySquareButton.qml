//方形按钮
import QtQuick 2.0
import QtQuick.Controls 2.2

Button{
    id: btn
    property color textColor: "white"
    property color defaultColor: '#5A6268'
    property color pressedColor: Qt.darker(defaultColor, 1.5)
    property alias imgSource: img.source
    contentItem: Text{
        text: btn.text
        color: btn.textColor
        font.family: 'Arial'
        font.pixelSize: 23
        font.weight: Font.Thin
        //设置文字居中
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        Image{
            id: img
            anchors.fill: parent
        }
    }
    background: Rectangle{
        implicitHeight: 40
        implicitWidth: 85
        radius: 5
        color: btn.down ? btn.pressedColor : btn.defaultColor
    }
}
