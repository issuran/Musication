package com.musication89

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