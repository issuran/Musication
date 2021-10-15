package com.musication89

import android.content.Context
import com.android.volley.VolleyError

class MainPresenter: VolleyResponseListener {
    var service: MusicationService? = null
    var delegate: PlayerDelegate? = null
    var latitude: String = ""
    var longitude: String = ""

    init {
        service = MusicationService()
    }

    fun requestNextSong(context: Context) {
        service?.requestNextSong(context, latitude, longitude, this)
    }

    fun updateCurrentLocation(latitude: Double, longitude: Double) {
        this.latitude = latitude.toString()
        this.longitude = longitude.toString()
    }

    override fun onResponse(model: MusicModel) {
        delegate?.playSong(model)
    }

    override fun onError(response: VolleyError) {
        val message = response.message ?: "Unexpected error"
        delegate?.handleError(message)
    }
}