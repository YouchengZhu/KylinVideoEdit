import QtQuick 2.0
import QtQuick.Controls 2.15

Item {  
    property alias playButton: playButton
    property alias cutButton: cutButton
    property alias finishButton: finishButton
    property alias audioButton: audioButton
    Row{
        spacing: 55
        MyRadioButton{
            id: playButton
            radius: 40
            color: "gray"
            imgHeight: 40
            imgWidth: 40
            opacity: 0.2
            imgSource: "images/播放 三角形.svg"
        }
        MyRadioButton{
            id: cutButton
            radius: 40
            color: "gray"
            opacity: 0.2
            imgHeight: 40
            imgWidth: 40
            imgSource: "images/等待.svg"
        }
        MyRadioButton{
            id: finishButton
            radius: 40
            color: "gray"
            opacity: 0.2
            imgHeight: 40
            imgWidth: 40
            imgSource: "images/完成.svg"

        }
        Row{
            spacing:8
            MyRadioButton{
                id: audioButton
                radius: 40
                color: "gray"
                opacity: 0.2
                imgHeight: 40
                imgWidth: 40
                imgSource: "images/音量.svg"

            }
            Slider{//进度条
                id: audioSlider
                visible: true
                width: 100
                y: (audioButton.height - height)/2
                to:100
                from: 0
                stepSize: 1
                value: 100
                onValueChanged: {
                    console.log(audioSlider.value / 100)
                    display.mediaPlayer.volume = audioSlider.value / 100
                }
            }
        }
    }
}
