import QtQuick 2.0
import QtQuick.Controls 2.5
Rectangle
{
    //确认信号（按下确认按钮发送，表示进行添加画中画的操作）
    signal confirm();

    property alias selectPicSource: pic.source;
    property var dragBackground: dragBackground;//父组件
    id:resizeRectangle
    property int enableSize: 15
    property bool isPressed: false
    property point customPoint
    color: "#00debff3"
    border.color: "#d37e49"
    readonly property int minWidth: 64
    readonly property int minHeight: 64

    property alias leftTopMouse: leftTopMouse
    property alias topMouse: topMouse;
    property alias rightTopMouse: rightTopMouse;
    property alias centerMouse: centerMouse
    property alias leftMouse: leftMouse;
    property alias rightMouse: rightMouse
    property alias leftBottomMouse: leftBottomMouse;
    property alias bottomMouse: bottomMouse
    property alias rightBottomMouse: rightBottomMouse;

    AnimatedImage{
        id: pic;
        anchors.fill: parent;
        MouseArea{
            acceptedButtons: Qt.RightButton
            anchors.fill: parent;
            onClicked: {
                console.log("click picInPic")
                contextMenu.x = mouse.x;
                contextMenu.y = mouse.y;
                contextMenu.open()
            }
        }
    }
    //右键弹出关闭的上下文菜单
    Menu{
        id: contextMenu;
        MenuItem{
            action: deleteAction;
        }
        MenuItem{
            action: okAction;
        }
    }
    Action{
        id: deleteAction;
        text: qsTr("删除")
        onTriggered: {
            console.log("deleteAction")
            resizeRectangle.visible = false;
        }
    }
    Action{
        id: okAction;
        text: qsTr("确认")
        //生成添加画中画的视频文件 且画中画的位置不能随意拖动
        onTriggered: {
            //清除画中画
            dialogs.addPicInPicDialog.targetVideoIndex = -1
            videoPlayWindow.picInPicWindow.visible = false;
            confirm();//发送确认信号（表示确认添加画中画的操作）
            console.log("okAction")
            leftTopMouse.enabled = false
            topMouse.enabled = false;
            rightTopMouse.enabled = false;
            centerMouse.enabled = false;
            leftMouse.enabled = false;
            rightMouse.enabled = false;
            leftBottomMouse.enabled = false;
            bottomMouse.enabled = false;
            rightBottomMouse.enabled = false;
        }
    }
    Rectangle
    {
        id: leftTop
        width: enableSize
        height: enableSize
        color: "white"
        border.width: 4
        border.color: "black"
        anchors.left: parent.left
        anchors.top: parent.top
        MouseArea
        {
            id: leftTopMouse
            anchors.fill: parent
            hoverEnabled: true
            onPressed: press(mouse)
            onEntered: enter(1)
            onReleased: release()
            onPositionChanged: positionChange(mouse, -1, -1)
        }
    }
    
    Item
    {
        id: top
        height: enableSize
        anchors.left: leftTop.right
        anchors.right: rightTop.left
        anchors.top: parent.top
        Rectangle{
            width: enableSize
            height: enableSize
            color: "white"
            border.width: 4
            border.color: "black"
            anchors.centerIn: parent;
        }
        MouseArea
        {
            id: topMouse
            anchors.fill: parent
            hoverEnabled: true
            onPressed: press(mouse)
            onEntered: enter(2)
            onReleased: release()
            onMouseYChanged: positionChange(Qt.point(customPoint.x, mouseY), 1, -1)
        }
    }

    Rectangle
    {
        id: rightTop
        width: enableSize
        height: enableSize
        color: "white"
        border.width: 4
        border.color: "black"
        anchors.right: parent.right
        anchors.top: parent.top

        MouseArea
        {
            id: rightTopMouse
            anchors.fill: parent
            hoverEnabled: true

            onPressed: press(mouse)
            onEntered: enter(3)
            onReleased: release()
            onPositionChanged: positionChange(mouse, 1, -1)
        }
    }

    Item
    {
        id: left
        width: enableSize
        anchors.left: parent.left
        anchors.top: leftTop.bottom
        anchors.bottom: leftBottom.top
        Rectangle{
            width: enableSize
            height: enableSize
            color: "white"
            border.width: 4
            border.color: "black"
            anchors.centerIn: parent;
        }
        MouseArea
        {
            id: leftMouse
            anchors.fill: parent
            hoverEnabled: true

            onPressed: press(mouse)
            onEntered: enter(4)
            onReleased: release()

            onMouseXChanged: positionChange(Qt.point(mouseX, customPoint.y), -1, 1)
        }
    }

    Item
    {
        id: center
        anchors.left: left.right
        anchors.right: right.left
        anchors.top: top.bottom
        anchors.bottom: bottom.top
        Rectangle{
            width: enableSize
            height: enableSize
            color: "white"
            border.width: 4
            border.color: "black"
            anchors.centerIn: parent;
        }
        MouseArea
        {
            id: centerMouse
            anchors.fill: parent
            property point clickPos

            onPressed: clickPos = Qt.point(mouse.x,mouse.y)
            onPositionChanged:
            {
                if(pressed)
                {
                    var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
                    resizeRectangle.x += delta.x
                    resizeRectangle.y += delta.y
                    fixedRetangle(0,0)
                }
            }
        }
    }

    Item
    {
        id: right
        width: enableSize
        anchors.right: parent.right
        anchors.top: rightTop.bottom
        anchors.bottom: rightBottom.top
        Rectangle{
            width: enableSize
            height: enableSize
            color: "white"
            border.width: 4
            border.color: "black"
            anchors.centerIn: parent;
        }
        MouseArea
        {
            id: rightMouse
            anchors.fill: parent
            hoverEnabled: true

            onPressed: press(mouse)
            onEntered: enter(6)
            onReleased: release()
            onMouseXChanged: positionChange(Qt.point(mouseX, customPoint.y), 1, 1)
        }
    }

    Rectangle
    {
        id: leftBottom
        width: enableSize
        height: enableSize
        color: "white"
        border.width: 4
        border.color: "black"
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        MouseArea
        {
            id: leftBottomMouse
            anchors.fill: parent
            hoverEnabled: true

            onPressed: press(mouse)
            onEntered: enter(7)
            onReleased: release()
            onPositionChanged: positionChange(mouse, -1, 1)
        }
    }

    Item
    {
        id: bottom
        height: enableSize
        anchors.left: leftBottom.right
        anchors.right: rightBottom.left
        anchors.bottom: parent.bottom
        Rectangle{
            width: enableSize
            height: enableSize
            color: "white"
            border.width: 4
            border.color: "black"
            anchors.centerIn: parent;
        }
        MouseArea
        {
            id: bottomMouse
            anchors.fill: parent
            hoverEnabled: true

            onPressed: press(mouse)
            onEntered: enter(8)
            onReleased: release()
            onMouseYChanged: positionChange(Qt.point(customPoint.x, mouseY), 1, 1)
        }
    }

    Rectangle
    {
        id:rightBottom
        width: enableSize
        height: enableSize
        color: "white"
        border.width: 4
        border.color: "black"
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        MouseArea
        {
            id: rightBottomMouse
            anchors.fill: parent
            hoverEnabled: true

            onPressed: press(mouse)
            onEntered: enter(9)
            onReleased: release()

            onPositionChanged: positionChange(mouse,1,1)
        }
    }

    function fixedRetangle(dx,dy)
    {
        if(resizeRectangle.width <= minWidth && resizeRectangle.height <= minHeight && dx <=0 && dy <= 0)
            return

        resizeRectangle.x -= dx*0.5
        resizeRectangle.y -= dy*0.5
        resizeRectangle.width += dx
        resizeRectangle.height += dy

        if(resizeRectangle.width < minWidth)
            resizeRectangle.width = minWidth
        if(resizeRectangle.height < minHeight)
            resizeRectangle.height = minHeight

        if(resizeRectangle.width > dragBackground.width)
            resizeRectangle.width = dragBackground.width
        if(resizeRectangle.height > dragBackground.height)
            resizeRectangle.height = dragBackground.height

        if(resizeRectangle.width + resizeRectangle.x > dragBackground.width)
            resizeRectangle.x = dragBackground.width - resizeRectangle.width
        if(resizeRectangle.height + resizeRectangle.y > dragBackground.height)
            resizeRectangle.y = dragBackground.height - resizeRectangle.height

        if(resizeRectangle.y < 0)
            resizeRectangle.y = 0

        if(resizeRectangle.x < 0)
            resizeRectangle.x = 0
    }

    function enter(direct)
    {
    }

    function press(mouse)
    {
        isPressed = true
        customPoint = Qt.point(mouse.x, mouse.y)
    }

    function release()
    {
        isPressed = false
    }

    function positionChange(newPosition,directX, directY)
    {
        if(!isPressed)
            return

        var delta = Qt.point(newPosition.x-customPoint.x, newPosition.y-customPoint.y)
        var tmpW,tmpH

        if(directX >= 0)
            tmpW = resizeRectangle.width + delta.x
        else
            tmpW = resizeRectangle.width - delta.x

        if(directY >= 0)
            tmpH = resizeRectangle.height + delta.y
        else
            tmpH = resizeRectangle.height - delta.y

        if(tmpW < resizeRectangle.minimumWidth)
        {
            if(directX < 0)
                resizeRectangle.x += (resizeRectangle.width - resizeRectangle.minimumWidth)
            resizeRectangle.width = resizeRectangle.minimumWidth
        }
        else
        {
            resizeRectangle.width = tmpW
            if(directX < 0)
                resizeRectangle.x += delta.x
        }

        if(tmpH < resizeRectangle.minimumHeight)
        {
            if(directY < 0)
                resizeRectangle.y += (resizeRectangle.height - resizeRectangle.minimumHeight)
            resizeRectangle.height = resizeRectangle.minimumHeight
        }
        else
        {
            resizeRectangle.height = tmpH
            if(directY < 0)
                resizeRectangle.y += delta.y
        }

        fixedRetangle(0,0)
    }
}

