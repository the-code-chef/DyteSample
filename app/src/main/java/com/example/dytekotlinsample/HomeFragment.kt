package com.example.dytekotlinsample

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.findNavController
import kotlinx.coroutines.*

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
class HomeFragment : Fragment() {

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.home_fragment, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        view.findViewById<Button>(R.id.createMeetingPageBtn).setOnClickListener {
            findNavController().navigate(R.id.action_Home_to_CreateMeeting);
        }

        view.findViewById<Button>(R.id.joinMeetingPageBtn).setOnClickListener {
            findNavController().navigate(R.id.action_Home_to_JoinMeeting);
        }
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        val actionBar = (activity as AppCompatActivity?)?.supportActionBar
        actionBar?.subtitle = "Home";
        actionBar?.setDisplayHomeAsUpEnabled(false)
    }
}