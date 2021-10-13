package com.example.musication

import java.util.*

object UserSession {

    var userId: String = ""

    init {
        createUUID()
    }

    fun createUUID() {
        userId = UUID.randomUUID().toString()
    }
}