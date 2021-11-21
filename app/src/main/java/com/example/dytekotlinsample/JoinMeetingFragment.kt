package com.example.dytekotlinsample

import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import com.dyteclientmobile.DyteMeeting
import com.dyteclientmobile.DyteMeetingActivity
import com.dyteclientmobile.MeetingConfig
import kotlinx.coroutines.*

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 * Use the [JoinMeetingFragment.newInstance] factory method to
 * create an instance of this fragment.
 */
class JoinMeetingFragment : Fragment() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.join_meeting_fragment, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        view.findViewById<Button>(R.id.joinMeetingBtn).setOnClickListener {
            val roomNameView = view.findViewById<EditText>(R.id.joinMeetingRoomNameField)
            val roomName = roomNameView.text.toString()
            if (roomName.isBlank()) {
                showAlert("Error", "Room Name Cannot be Empty!")
                roomNameView.requestFocus()
                return@setOnClickListener
            }
            joinMeeting(roomName)
        }
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        val actionBar = (activity as AppCompatActivity?)?.supportActionBar
        actionBar?.subtitle = "Join Meeting"
    }

    private fun joinMeeting(roomName: String) {
        val config = MeetingConfig()
        config.setRoomName(roomName)

        DyteMeeting.setup(config)

        val meetingIntent = Intent(activity, DyteMeetingActivity::class.java)
        startActivity(meetingIntent)
    }

    private fun showAlert(title: String, message: String?) {
        AlertDialog.Builder(this.context).setTitle(title)
            .setMessage(message)
            .setPositiveButton(android.R.string.ok) { _, _ -> }
            .setIcon(android.R.drawable.ic_dialog_alert).show()
    }

}