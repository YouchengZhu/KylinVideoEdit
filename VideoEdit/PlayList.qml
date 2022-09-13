import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.12

Item {
    property alias view: view
    property var sum: []
    property var queue: []

    function isHasChecked()
    {
        var count = 0;
        for(var i = 0; i < sum.length;i++)
        {
            if(sum[i] % 2 == 0) {
                sum[i] = 0;
                continue;
            }
            count++;
            if(count >= 2) return true;
        }
        return false;
    }
    function selectFiles(fileNames)
    {
        display.mediaPlayer.playlists.clear();
        for(var i = 0; i < fileNames.length; i++)
        {
            display.mediaPlayer.playlists.addItem(fileNames[i])
        }
    }
    function convertFileName(source)
    {
        var pos = JSON.stringify(source).lastIndexOf('/');
        var name = JSON.stringify(source).substr(pos + 1);
        var finalName = name.substr(0, name.length - 1);
        return finalName;
    }
    Rectangle{
        anchors.fill: parent
        color: "#F7F7F7"
        ListView{
            id: view
            anchors.fill: parent
            model: display.mediaPlayer.playlists
            clip: true
            spacing: 3
            focus: true
            currentIndex: -1
            property var lastCurrentIndex: -1
            delegate: Rectangle{
                id: rect
                height: 50
                width: parent.width
                radius: 5
                border.color: Qt.lighter(color, 1.1)
                border.width: 5
                color: "#EEEEEE"
                CheckDelegate{
                    id: box
                    height: 50
                    width: parent.width
                    text: "           ";
                    checked: false

                    Text{
                        anchors.fill: parent
                        anchors.leftMargin: 15;
                        anchors.rightMargin: 50
                        anchors.centerIn: parent
                        font.pixelSize: 20
                        verticalAlignment: Text.AlignVCenter
                        color: "black"
                        elide: Text.ElideRight
                        text: convertFileName(source);
                        font.family: "Arial"
                        font.weight: Font.Thin
                    }
                }
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true
                    onPressed: {
                        display.mediaPlayer.playlists.currentIndex = index
                        bottomContainer.playButton.imgSource = "images/暂停2.svg"
                        if(display.mediaPlayer.playbackState !== MediaPlayer.PlayingState){
                            display.mediaPlayer.play();
                        }
                        if (view.lastCurrentIndex != -1) {
                            if(view.itemAtIndex(view.lastCurrentIndex)){
                                view.itemAtIndex(view.lastCurrentIndex).color = "#EEEEEE"
                            }
                        }
                        view.currentIndex = index
                        if(view.lastCurrentIndex != index)
                        {
                            display.rangeSlider.visible = false
                            display.slider.visible = true
                            display.rangeSlider.first.value = 0
                            display.rangeSlider.second.value = 0
                        }

                        color = "#CCCCCC"
                        view.lastCurrentIndex = index

                        box.checked = !(box.checked)
                        sum[view.currentIndex]++;
                        if(sum[view.currentIndex] % 2 != 0) {
                            console.log(view.currentIndex)
                            queue.push(view.currentIndex)
                        }
                    }
                    onEntered:{
                        if(view.currentIndex == index)
                        {
                            return
                        }
                        color = "#D5D5D5"
                    }
                    onExited: {
                        if(view.currentIndex == index)
                        {
                            return
                        }
                        color = "#EEEEEE"
                    }
                }

            }
        }
    }
}
