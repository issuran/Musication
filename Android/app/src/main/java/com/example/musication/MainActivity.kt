package com.example.musication

import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.ImageButton
import android.widget.TextView
import java.io.IOException

class MainActivity : AppCompatActivity() {

    private val audioPath = "https://65381g.ha.azioncdn.net/e/c/b/3/vaqueirosmoficial-hoje-tem-feat-rai-saia-rodada-785260ab.mp3"
    private var mediaPlayer = MediaPlayer()
    private var isPlaying = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        var trackState = findViewById<TextView>(R.id.playState)
        var playButton = findViewById<ImageButton>(R.id.playPauseButton)
        var backButton = findViewById<ImageButton>(R.id.backButton)
        var nextButton = findViewById<ImageButton>(R.id.nextButton)

        playButton.setOnClickListener {
            if (isPlaying) {
                trackState.text = "Paused"
                playButton.setImageResource(R.drawable.play)
                try {
                    mediaPlayer.stop()
                    mediaPlayer.reset()
                    mediaPlayer.release()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            } else {
                trackState.text = "Playing"
                playButton.setImageResource(R.drawable.pause_button)
                mediaPlayer = MediaPlayer().apply {
                    setAudioAttributes(
                        AudioAttributes
                            .Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                            .setUsage(AudioAttributes.USAGE_MEDIA)
                            .build()
                    )
                    setDataSource(audioPath)
                    prepare()
                    start()
                }
            }
            isPlaying = !isPlaying
        }

    }

}