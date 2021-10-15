package com.musication89

class MusicModel {
    var musicArtist: String = ""
    var musicName: String = ""
    var urlTrack: String = ""

    constructor(musicArtist: String, musicName: String, urlTrack: String) {
        this.musicArtist = musicArtist
        this.musicName = musicName
        this.urlTrack = urlTrack
    }

}