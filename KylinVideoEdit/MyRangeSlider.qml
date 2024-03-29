import QtQuick 2.0
import QtQuick.Controls 2.12


RangeSlider {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            first.implicitHandleWidth + leftPadding + rightPadding,
                            second.implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             first.implicitHandleHeight + topPadding + bottomPadding,
                             second.implicitHandleHeight + topPadding + bottomPadding)

    padding: 6

    first.handle: Rectangle {
        id:rect
        x: control.leftPadding + (control.horizontal ? control.first.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.first.visualPosition * (control.availableHeight - height))
        implicitWidth: 5
        implicitHeight: 28
        radius: width / 2
        border.width: activeFocus ? 2 : 1
        border.color: activeFocus ? control.palette.highlight : control.enabled ? control.palette.mid : control.palette.midlight
        color:"black"

    }

    second.handle: Rectangle {
        x: control.leftPadding + (control.horizontal ? control.second.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.second.visualPosition * (control.availableHeight - height))
        implicitWidth: 5
        implicitHeight: 28
        radius: width / 2
        border.width: activeFocus ? 2 : 1
        border.color: activeFocus ? control.palette.highlight : control.enabled ? control.palette.mid : control.palette.midlight
        color: "black"
    }

    background: Rectangle {
        x: control.leftPadding + (control.horizontal ? 0 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : 0)
        implicitWidth: control.horizontal ? 200 : 6
        implicitHeight: 25
        width: control.horizontal ? control.availableWidth : implicitWidth
        height: control.horizontal ? implicitHeight : control.availableHeight
        radius: 3
        color: control.palette.midlight
        scale: control.horizontal && control.mirrored ? -1 : 1

        Rectangle {
            x: control.horizontal ? control.first.position * parent.width + 3 : 0
            y: control.horizontal ? 0 : control.second.visualPosition * parent.height + 3
            width: control.horizontal ? control.second.position * parent.width - control.first.position * parent.width - 6 : 6
            height: 25

            color:"yellow"
        }
    }
}

