import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.12

Item {
    property alias view: view
    signal play();
    signal pauseVideo()
    signal pauseAudio()
    property var sum: []
    property var chosedSource: []
    property var isCurrentVideo

    property alias listModel: view.model//对应两个音视频播放窗口
    property var currentPlayWindow;//当前列表对应播放窗口
    signal click();//列表数据项点击激发信号


    //property alias box: view.box
    //函数一: 判断当前列表项中是否有不少于两个列表项被点击
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
        //currentPlayWindow.playlists.clear();
        for(var i = 0; i < fileNames.length; i++)
        {
            currentPlayWindow.playlists.addItem(fileNames[i])
        }
    }

    function selectBgmFiles(fileNames)
    {
        currentPlayWindow.playlists.clear();
        for(var i = 0; i < fileNames.length; i++)
        {
            currentPlayWindow.playlists.addItem(fileNames[i])
        }
    }

    //函数二：判断当前列表项中是否有列表项被点击
    function isChecked()
    {
        var count = 0;
        for(var i = 0; i < sum.length;i++)
        {
            if(sum[i] % 2 == 0) {
                sum[i] = 0;
                continue;
            }
            count++;
            if(count > 0) return true;
        }
        return false;
    }
    //函数三: 判断视频列表切换后画中画是否在目标视频
    function isTargetVideoIndex(targetVideoIndex)
    {
        if(videoPlayWindow.playlists.currentIndex === targetVideoIndex)
        {

            return true;
        }

        return false;
    }
    //函数四：转换文件路径名
    function convertFileName(source)
    {
        var pos = JSON.stringify(source).lastIndexOf('/');
        var name = JSON.stringify(source).substr(pos + 1);
        var finalName = name.substr(0, name.length - 1);
        return finalName;
    }

    //函数五:对数组进行逆序
    function reverse(arr){
        var temp;
        for(var i=0;i < arr.length/2;i++){
        temp=arr[i];
        arr[i]=arr[arr.length-1-i];
        arr[arr.length-1-i]=temp;
        }
        return arr;
    }


    //函数六：数组去重
    function unique(arr) {
        return Array.from(new Set(arr))
    }

    //函数七：对合并数组进行检查
    function check(arr)
    {
        var tmp = []
        for (var i = 0;i < sum.length;i++)
        {
            if (sum[i] % 2 !== 0) tmp.push(i)
        }

        var finalArr = []

        for (var i = 0;i < arr.length;i++)
        {
            for (var j = 0;j < tmp.length;j++)
            {
                if(arr[i] === tmp[j]) finalArr.push(arr[i])
            }
        }
        return finalArr;
    }

    Rectangle{
        anchors.fill: parent
        color: "#F7F7F7"
        ListView{
            id: view
            anchors.fill: parent
            //显示播放列表中的文件路径
            model: currentPlayWindow.playlists
            clip: true
            spacing: 3
            focus: true
            currentIndex: -1
            property var lastCurrentIndex: -1;
            delegate: Rectangle{
                id: rect;
                height: 50
                width: parent.width;
                radius: 5;
                border.color: Qt.lighter(color, 1.1)
                border.width: 5
                color: "#EEEEEE"
                //可选择项
                CheckDelegate
                {
                    id: box;
                    height: 50
                    width: parent.width
                    text: "         ";
                    checked: false
                    //设置字体
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
                    Connections{
                        target: dialogs.videoFileDialog
                        onAccepted: {
                            box.checked = false
                        }
                    }
                    Connections{
                        target: dialogs.audioFileDialog
                        onAccepted: {
                            box.checked = false
                        }
                    }

                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: {
                        //1.当前列表项为点击列表项
                        currentPlayWindow.playlists.currentIndex = index
                        //点击列表项为视频
                        if(currentPlayWindow === videoPlayWindow)
                        {
                            //1.调整窗口可见性
                            audioPlayWindow.visible = false;
                            videoPlayWindow.visible = true
                            //2.将音频暂停
                            pauseAudio();
                            //---------点击列表项切换 画中画
                            if(isTargetVideoIndex(dialogs.addPicInPicDialog.targetVideoIndex))
                            {
                                videoPlayWindow.picInPicWindow.visible = true;
                            }else{
                                videoPlayWindow.picInPicWindow.visible = false;
                                //-------不出现在目标视频文件中
                                videoPlayWindow.picInPicWindow.visible = false;
                                videoPlayWindow.picInPicWindow.leftTopMouse.enabled = true;
                                videoPlayWindow.picInPicWindow.topMouse.enabled = true;
                                videoPlayWindow.picInPicWindow.rightTopMouse.enabled = true;
                                videoPlayWindow.picInPicWindow.centerMouse.enabled = true;
                                videoPlayWindow.picInPicWindow.leftMouse.enabled = true;
                                videoPlayWindow.picInPicWindow.rightMouse.enabled = true;
                                videoPlayWindow.picInPicWindow.leftBottomMouse.enabled = true;
                                videoPlayWindow.picInPicWindow.bottomMouse.enabled = true;
                                videoPlayWindow.picInPicWindow.rightBottomMouse.enabled = true;
                            }
                        }else if(currentPlayWindow === audioPlayWindow)//点击列表项为音频
                        {
                            //1.调整窗口可见性
                            audioPlayWindow.visible = true;
                            videoPlayWindow.visible = false;
                            //2.将视频暂停
                            pauseVideo();
                        }else{
                            //1.将音频暂停
                            pauseAudio();
                            //2.将视频暂停
                            pauseVideo();
                        }
                        //调整播放图标 未写代码
                        //设置播放
                        if(currentPlayWindow.playbackState !== MediaPlayer.PlayingState){
                            play();
                         }
                        if (view.lastCurrentIndex != -1) {
                            if(view.itemAtIndex(view.lastCurrentIndex)){
                                view.itemAtIndex(view.lastCurrentIndex).color = "#EEEEEE"
                            }
                        }
                        view.currentIndex = index
                        color = "#CCCCCC"
                        view.lastCurrentIndex = index

                        box.checked = !(box.checked)
                        sum[view.currentIndex]++;//当前列表项点击数++
                        //记录点击顺序
                        if(sum[view.currentIndex] % 2 != 0) {
                            chosedSource.push(view.currentIndex)
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
