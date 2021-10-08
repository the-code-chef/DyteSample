package com.example.dytekotlinsample

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Body
import retrofit2.http.POST

data class Meeting(
    val id: String,
    val title: String,
    val roomName: String,
    val status: String,
    val createdAt: String
)

data class MeetingResponse(
    val success: Boolean,
    val meeting: Meeting
);

data class CreateMeetingBody(
    val title: String,
    val authorization: Authorization
)

data class Authorization(
    val waitingRoom: Boolean
)

data class AddParticipantBody(
    val isHost: Boolean,
    val isWebinar: Boolean,
    val displayName: String,
    val meetingId: String,
    val clientSpecificId: String
)

data class AuthResponse(
    val userAdded: Boolean,
    val authToken: String
)

data class AddParticipantResponse(
    val authResponse: AuthResponse
)

interface DyteAPIService {
    @POST("/api/meeting")
    suspend fun createMeeting(@Body params: CreateMeetingBody): MeetingResponse

    @POST("/api/participant")
    suspend fun addParticipant(@Body params: AddParticipantBody): AddParticipantResponse
}

public class DyteAPI {
    private val service: DyteAPIService

    companion object {
        const val BASE_URL = "https://app.dyte.in/"
    }

    init {
        val retrofit = Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
        service = retrofit.create(DyteAPIService::class.java)
    }

    suspend fun createMeeting(body: CreateMeetingBody): MeetingResponse {
        return service.createMeeting(body)
    }

    suspend fun addParticipant(body: AddParticipantBody): AddParticipantResponse {
        return service.addParticipant(body)
    }
}