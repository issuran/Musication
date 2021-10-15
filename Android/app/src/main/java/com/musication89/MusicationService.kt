package com.musication89

import android.content.Context
import com.android.volley.Request
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import org.json.JSONObject
import com.android.volley.VolleyError
import org.json.JSONException

interface VolleyResponseListener {
    fun onResponse(model: MusicModel)
    fun onError(response: VolleyError)
}

class MusicationService {

    fun requestNextSong(context: Context, latitude: String, longitude: String, volleyResponseListener: VolleyResponseListener) {
        val queue = Volley.newRequestQueue(context)
        val url = "https://stark-shelf-44081.herokuapp.com/musication/songLocation"

        val postData = JSONObject()
        try {
            postData.put("latitude", latitude)
            postData.put("longitude", longitude)
            postData.put("userId", UserSession.userId)

        } catch (e: JSONException) {
            e.printStackTrace()
        }

        val jsonObjectRequest = JsonObjectRequest(
            Request.Method.POST,
            url,
            postData, {
                    response ->
                var model: MusicModel? = null
                try {
                    val artistName = response.getString("musicArtist")
                    val musicName = response.getString("musicName")
                    val urlTrack = response.getString("urlTrack")

                    model = MusicModel(artistName, musicName, urlTrack)
                    volleyResponseListener.onResponse(model)

                } catch (e: JSONException) {
                    e.printStackTrace()
                }
            },
            { error ->
                volleyResponseListener.onError(error)
            }
        )

        queue.add(jsonObjectRequest)
    }
}
