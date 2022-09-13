import QtQuick 2.0

Item {
    height: 100
    property alias finishBtn: finishBtn;
    property alias musicBtn: musicBtn
    MyRadioButton{
        id: radioBtn
        x: 15; y: 15
        radius: 30
        opacity: 0.1
        color: "gray"
        text: qsTr("\u2630")
        onClicked: drawer.open()
    }
    Row{
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        MySquareButton{
            id: musicBtn
            text: qsTr("背景音乐")
            textColor: "black"
            defaultColor: "gray"
            opacity: 0.5
        }
        MySquareButton{
            id: finishBtn
            text: qsTr("完成视频")
            textColor: "black"
            defaultColor: "gray"
            opacity: 0.5
        }
    }
}
