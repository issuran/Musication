package com.example.musication

import android.Manifest
import android.content.pm.PackageManager
import android.media.AudioAttributes
import android.media.MediaPlayer
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.ImageButton
import android.widget.TextView
import android.widget.Toast
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import java.io.IOException

interface PlayerDelegate {
    fun playSong(model: MusicModel)
    fun stopSong()
    fun handleError(error: String)
}

class MainActivity : AppCompatActivity(), PlayerDelegate {

    private lateinit var trackState: TextView
    private lateinit var playButton: ImageButton
//    private var backButton: ImageButton = findViewById(R.id.backButton)
    private lateinit var nextButton: ImageButton

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private val audioPath = "https://65381g.ha.azioncdn.net/c/4/e/6/lisandro-eithne-ni-bhronin-dedicada-enya.mp3"
    private var mediaPlayer = MediaPlayer()
    private var isPlaying = false
    private var presenter: MainPresenter? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        configurePresenter()
        setupView()
    }

    private fun configurePresenter() {
        presenter = MainPresenter()
        presenter?.delegate = this
    }

    private fun setupView() {
        trackState = findViewById(R.id.playState)
        playButton = findViewById(R.id.playPauseButton)
//    private var backButton: ImageButton = findViewById(R.id.backButton)
        nextButton = findViewById(R.id.nextButton)

        playButton.setOnClickListener {
            if (!isPlaying) {
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
        getLastKnownLocation()
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

    fun getLastKnownLocation() {
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }

        fusedLocationClient.lastLocation.addOnSuccessListener { location ->
            if (location != null) {
                presenter?.updateCurrentLocation(location.latitude, location.longitude)
            }
        }
    }

    override fun playSong(model: MusicModel) {
        isPlaying = !isPlaying

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

        mediaPlayer.setOnCompletionListener {
            startSong()
        }
    }

    override fun stopSong() {
        pauseSong()
    }

    override fun handleError(error: String) {
        Toast.makeText(this, error, Toast.LENGTH_LONG).show()
    }

}