package com.example.musication

import android.media.AudioAttributes
import android.media.MediaPlayer
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.ImageButton
import android.widget.TextView
import android.widget.Toast
import java.io.IOException

interface PlayerDelegate {
    fun playSong(model: MusicModel)
    fun stopSong()
    fun handleError(error: String)
}

class MainActivity : AppCompatActivity(), PlayerDelegate {

    private var trackState: TextView = findViewById(R.id.playState)
    private var playButton: ImageButton = findViewById(R.id.playPauseButton)
//    private var backButton: ImageButton = findViewById(R.id.backButton)
    private var nextButton: ImageButton = findViewById(R.id.nextButton)

    private val audioPath = "https://65381g.ha.azioncdn.net/e/c/b/3/vaqueirosmoficial-hoje-tem-feat-rai-saia-rodada-785260ab.mp3"
    private var mediaPlayer = MediaPlayer()
    private var isPlaying = false
    private var presenter: MainPresenter? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        configurePresenter()
        setupView()
    }

    private fun configurePresenter() {
        presenter = MainPresenter()
        presenter?.delegate = this
    }

    private fun setupView() {
        playButton.setOnClickListener {
            isPlaying = !isPlaying

            if (isPlaying) {
                startSong()
            } else {
                pauseSong()
            }
        }

        nextButton.setOnClickListener {
            nextSong()
        }
    }

    private fun startSong() {
        isPlaying = true
        presenter?.requestNextSong(this)
    }

    private fun pauseSong() {
        isPlaying = false
        trackState.text = getString(R.string.pausedString)
        playButton.setImageResource(R.drawable.play)
        try {
            mediaPlayer.stop()
            mediaPlayer.reset()
            mediaPlayer.release()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    private fun nextSong() {
        startSong()
    }

    override fun playSong(model: MusicModel) {
        trackState.text = getString(R.string.playingString)
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

    override fun stopSong() {
        pauseSong()
    }

    override fun handleError(error: String) {
        Toast.makeText(this, error, Toast.LENGTH_LONG).show()
    }

}