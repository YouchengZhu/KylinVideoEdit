//剪辑工具栏组件
import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    //1.拆分
    property alias splitBtn: splitBtn
    //2.裁剪
    property alias cutBtn: cutBtn
    //3.画中画
    property alias picInPicBtn: picInPicBtn
    //4.截屏
    property alias screenShotBtn: screenShotBtn
    //5.完成
    property alias finishBtn: finishBtn
    Row{
        spacing: 55
        MyRadioButton{
            id: splitBtn
            radius: 40
            color: "gray"
            imgHeight: 40
            imgWidth: 40
            opacity: 0.2
            imgSource: "images/拆分.svg"
        }
        MyRadioButton{
            id: cutBtn
            radius: 40
            color: "gray"
            opacity: 0.2
            imgHeight: 40
            imgWidth: 40
            imgSource: "images/裁剪.svg"
        }
        MyRadioButton{
            id: finishBtn
            visible: false
            radius: 40
            color: "gray"
            opacity: 0.2
            imgHeight: 40
            imgWidth: 40
            imgSource: "images/完成.svg"
        }
        MyRadioButton{
            id: picInPicBtn
            radius: 40
            color: "gray"
            opacity: 0.2
            imgHeight: 40
            imgWidth: 40
            imgSource: "images/画中画.svg"
        }
        MyRadioButton{
            id: screenShotBtn
            radius: 40
            color: "gray"
            opacity: 0.2
            imgHeight: 40
            imgWidth: 40
            imgSource: "images/截屏.svg"
        }
    }
}

