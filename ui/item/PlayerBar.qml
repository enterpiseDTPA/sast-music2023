import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import FluentUI
import sast_music
import "../component"

BlurRectangle {
    id: playerBar
    property Item stackView
    property Animation animationup
    property int volumeValue
    property Item rec_lyrics
    height: 60
    blurRadius: 100
    target: stackView

    MouseArea {
        anchors.fill: parent
        onClicked: {
            animationup.start()
        }
    }

    Connections {
        target: animationup
        function onFinished() {
            rec_lyrics.y = 0
        }
    }

    FluClip {
        id: image_song
        radius: [3, 3, 3, 3]
        width: 45
        height: 45
        anchors {
            left: parent.left
            leftMargin: 65
            verticalCenter: parent.verticalCenter
        }
        FluImage {
            anchors.fill: parent
            source: "qrc:///res/img/netease-music.png"
        }
        FluShadow {}
    }

    Text {
        id: text_song
        text: "Song"
        width: 100
        elide: Text.ElideRight
        maximumLineCount: 1
        font.family: "Barlow-Bold"
        font.bold: true
        font.pixelSize: 16
        anchors {
            left: image_song.right
            leftMargin: 10
            top: parent.top
            topMargin: 10
        }
    }

    Text {
        id: text_singer
        text: "singer"
        width: 100
        elide: Text.ElideRight
        maximumLineCount: 1
        font.family: "Barlow-Bold"
        font.pixelSize: 12
        color: "#73706c"
        anchors {
            left: image_song.right
            leftMargin: 10
            top: parent.top
            topMargin: 35
        }
    }

    IconButton {
        property bool liked: false
        width: 30
        height: 30
        iconUrl: liked ? "qrc:///res/img/heart.svg" : "qrc:///res/img/heart-solid.svg"
        anchors {
            left: image_song.right
            leftMargin: 20 + Math.max(text_song.implicitWidth,
                                      text_singer.implicitWidth)
            verticalCenter: parent.verticalCenter
        }
        onClicked: {
            liked = !liked
        }
    }

    IconButton {
        anchors {
            right: btn_play.left
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }
        iconUrl: "qrc:///res/img/previous.svg"
    }

    IconButton {
        id: btn_play
        property bool playing: true
        anchors.centerIn: parent
        width: 40
        height: 40
        radius: 10
        iconWidth: 20
        iconHeight: 25
        iconUrl: playing ? "qrc:///res/img/play.svg" : "qrc:///res/img/pause.svg"
        onClicked: {
            playing = !playing
        }
    }

    IconButton {
        anchors {
            left: btn_play.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
        iconUrl: "qrc:///res/img/next.svg"
    }

    IconButton {
        anchors {
            right: parent.right
            rightMargin: 65
            verticalCenter: parent.verticalCenter
        }
        id: btn_arrow_up
        iconUrl: "qrc:///res/img/arrow-up.svg"
        onClicked: {
            animationup.start()
        }
    }

    MusicSlider {
        id: slider
        anchors {
            right: btn_arrow_up.left
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        value: VolumeViewModel.volume
        width: 85
        active: item_mouse_slider.containsMouse
        handleVisible: item_mouse_slider.containsMouse
        onValueChanged: {
            VolumeViewModel.volume = value
        }
    }
    MouseArea {
        id: item_mouse_slider
        propagateComposedEvents: true
        width: 85
        anchors {
            right: btn_arrow_up.left
            rightMargin: 10
            top: parent.top
            bottom: parent.bottom
            topMargin: 15
            bottomMargin: 15
        }
        onClicked: mouse => mouse.accepted = false
        onPressAndHold: mouse => mouse.accepted = false
        onPressed: mouse => mouse.accepted = false
        onReleased: mouse => mouse.accepted = false
        hoverEnabled: true
    }

    Row {
        anchors {
            right: slider.left
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        spacing: 10

        IconButton {
            iconUrl: "qrc:///res/img/list.svg"
            onClicked: {
                stackView.pushPage("qrc:///ui/page/T_palyList.qml")
            }
        }
        IconButton {
            iconUrl: "qrc:///res/img/repeat.svg"
        }
        IconButton {
            iconUrl: "qrc:///res/img/shuffle.svg"
        }
        IconButton {
            id: btn_volume
            property bool mute: VolumeViewModel.volume === 0
            iconUrl: mute ? "qrc:///res/img/volume-mute.svg" : (slider.value > 50 ? "qrc:///res/img/volume.svg" : "qrc:///res/img/volume-half.svg")
            onClicked: {
                if (!mute) {
                    volumeValue = VolumeViewModel.volume
                    VolumeViewModel.volume = 0
                } else {
                    VolumeViewModel.volume = volumeValue
                }
            }
        }
    }
}
