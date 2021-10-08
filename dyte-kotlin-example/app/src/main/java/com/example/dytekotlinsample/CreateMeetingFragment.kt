package com.example.dytekotlinsample

import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.findNavController
import com.dyteclientmobile.DyteMeeting
import com.dyteclientmobile.DyteMeetingActivity
import com.dyteclientmobile.MeetingConfig
import kotlinx.coroutines.*

/**
 * A simple [Fragment] subclass as the second destination in the navigation.
 */
class CreateMeetingFragment : Fragment() {

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.create_meeting_fragment, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        view.findViewById<Button>(R.id.createMeetingBtn).setOnClickListener {
            val meetingTitleView = view.findViewById<EditText>(R.id.createMeetingTitleField)
            val meetingTitle = meetingTitleView.text.toString()

            val displayNameView = view.findViewById<EditText>(R.id.createMeetingDisplayNameField)
            val displayName = displayNameView.text.toString()

            if (meetingTitle.isBlank()) {
                showAlert("Error", "Meeting Title Cannot be Empty!")
                meetingTitleView.requestFocus()
                return@setOnClickListener
            } else if (displayName.isBlank()) {
                showAlert("Error", "Display Name Cannot be Empty!")
                displayNameView.requestFocus()
                return@setOnClickListener
            }
            createNewMeeting(meetingTitle, displayName)
        }
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        val actionBar = (activity as AppCompatActivity?)?.supportActionBar
        actionBar?.subtitle = "Create Meeting"
    }

    private fun createNewMeeting(meetingTitle: String, displayName: String) {
        val mainActivityJob = Job()

        val errorHandler = CoroutineExceptionHandler { _, exception ->
            showAlert("Error", exception.message)
        }

        val coroutineScope = CoroutineScope(mainActivityJob + Dispatchers.Main)
        coroutineScope.launch(errorHandler) {
            val api = DyteAPI()
            val meeting = api.createMeeting(CreateMeetingBody(meetingTitle, Authorization(false))).meeting;
            val participantResponse = api.addParticipant(AddParticipantBody(true, false, displayName, meeting.id, "kotlinSample"))

            AlertDialog.Builder(this@CreateMeetingFragment.context).setTitle("Meeting Created Successfully!")
                .setMessage("Room Name: " + meeting.roomName)
                .setPositiveButton("Join Meeting") {_, _ ->
                    val config = MeetingConfig()
                    config.setRoomName(meeting.roomName)
                    config.setAuthToken(participantResponse.authResponse.authToken)

                    DyteMeeting.setup(config)

                    val meetingIntent = Intent(activity, DyteMeetingActivity::class.java)
                    startActivity(meetingIntent)
                }
                .setIcon(android.R.drawable.ic_dialog_alert).show()
        }
    }

    private fun showAlert(title: String, message: String?) {
        AlertDialog.Builder(this.context).setTitle(title)
            .setMessage(message)
            .setPositiveButton(android.R.string.ok) { _, _ -> }
            .setIcon(android.R.drawable.ic_dialog_alert).show()
    }
}