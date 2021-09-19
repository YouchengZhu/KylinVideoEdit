import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.12

Item {
    property alias mediaPlayer: player
    property alias playlists: player.playlists
    property alias playbackState: player.playbackState
    Rectangle{
        id: video
        width: 50
        height: 50
        MediaPlayer{
            id: player;
            property alias playlists: playlists;
            playlist: Playlist{
                id: playlists
            }
        }
        VideoOutput{
            id: videoOutput;
            width: parent.width
            height: parent.height
            anchors.top: parent.top
            source: player
        }
    }
}

