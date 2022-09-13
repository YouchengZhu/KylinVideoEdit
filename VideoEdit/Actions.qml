import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    property alias openAction:open
    Action{
        id: open
        text: qsTr("Add video..")
        icon.name: "document-open"
        shortcut: "StandardKey.Open"
    }
}
