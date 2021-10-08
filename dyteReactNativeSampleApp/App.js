import { DyteMeeting, Meeting } from "@dytesdk/mobile";
import {View, Text, TouchableOpacity, StyleSheet, Dimensions} from 'react-native'
import React from 'react'
import { registerGlobals } from 'react-native-webrtc';

registerGlobals();

function App() {
  const [meetingStatus, setMeetingStatus] = React.useState(false)
  const {width, height} = Dimensions.get('window')
  const meetingRef = React.useRef(null);

  const onMeetingInit = (meeting) => {
		meetingRef.current = meeting;

		meeting.on(meeting.Events.meetingEnded, () => {
      setMeetingStatus(false)
		});
		
	};
  if (meetingStatus) {
    return (
            <DyteMeeting
                onInit={(meeting) => { }}
                clientId={undefined}
                onInit={onMeetingInit}
                meetingConfig={{
                    roomName: `hlcckr-gqjszg`
                }}
            />
    );
  } else {
    return (
      <View style={{
        display: 'flex', 
        justifyContent: 'center',
        alignItems: 'center', 
        width: width,
        height: height
      }}> 

        <TouchableOpacity style={{
          width: 200, 
          height: 50, 
          backgroundColor: '#1E88E5',
          alignItems: 'center',
          justifyContent: 'center',
          borderRadius: 10
        }}
        onPress={() => setMeetingStatus(true)}
        > 
          <Text style={{
            color: 'white'
          }}> Join Meeting</Text>
        </TouchableOpacity>
      </View>
    )
  }
}


export default App;