import UIKit
import DyteSdk;
import Foundation

struct CreateMeeting : Encodable {
    var title:String?
    var authorization:Authorization?
}

struct Authorization: Encodable {
    var waitingRoom:Bool
}

struct Participant:Decodable {
    let name: String?
    let id: String
    let picture: String?
    let isScreensharing: Bool
    let isPinned: Bool
    let videoEnabled: Bool
    let audioEnabled: Bool
}

struct  MeetingResponse: Decodable {
    let id,title, roomName, status, createdAt:String
    let participants: [Participant]
}

struct MeetingResponseRoot:Decodable {
    let meeting:MeetingResponse
}

struct CreateParticipant: Encodable {
    let isHost, isWebinar: Bool
    let displayName, meetingId, clientSpecificId:String
}

struct AuthResponse: Decodable {
    let userAdded:Bool
    let authToken:String
}

struct ParticipantResponseRoot: Decodable {
   let authResponse:AuthResponse
}






class CreateMeetingViewController: UIViewController {
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var hostName: UITextField!
    @IBOutlet weak var meetingName: UITextField!
    fileprivate var dyteView: DyteMeetingView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureTextField()
    }
    

    public func noErrors () {
        hostName.layer.borderWidth = 0
        meetingName.layer.borderWidth = 0
        errorMessage.isHidden = true
    }
    
    private func configureTextField() {
        hostName.delegate = self
        meetingName.delegate = self
    }
    
    private func createMeeting() {
        
        let meetingAuthorizationParams = Authorization(waitingRoom: false)
        let createMeetingParams = CreateMeeting(title: meetingName.text, authorization: meetingAuthorizationParams)
        let createMeetingUrl = URL(string: "https://app.dyte.in/api/meeting")!
        let meetingBodyData =  try! JSONEncoder().encode(createMeetingParams)
        var request = URLRequest(url: createMeetingUrl)
        request.httpMethod = "POST"
        request.httpBody = meetingBodyData;
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let createMeetingData = data else {
                return
            }
            do {
                let res = try JSONDecoder().decode(MeetingResponseRoot.self, from: createMeetingData)
                let addParticipantParams = CreateParticipant(isHost: true, isWebinar: false, displayName: self.hostName.text!, meetingId: res.meeting.id, clientSpecificId: "demoSwiftApp")
                
                let addParticipantUrl = URL(string: "https://app.dyte.in/api/participant")!
                let participantDataBody =  try! JSONEncoder().encode(addParticipantParams)
                request = URLRequest(url: addParticipantUrl)
                request.httpMethod = "POST"
                request.httpBody = participantDataBody;
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
                let participantRequest = URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
                    guard let self = self else {
                        return
                    }
                    guard let responseCode = response as? HTTPURLResponse, responseCode.statusCode == 200, let participantMeetingData = data else {
                        return
                    }
                    do {
                        let parRes = try JSONDecoder().decode(ParticipantResponseRoot.self, from: participantMeetingData)
                        DispatchQueue.main.async {
                            let  config = DyteMeetingConfig();
                            config.roomName = res.meeting.roomName;
                            config.authToken = parRes.authResponse.authToken;

                            let dyteView = DyteMeetingView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height:self.view.bounds.size.height ))
                            dyteView.delegate = self
                            dyteView.tag  = 100
                            self.dyteView = dyteView;
                            self.view.addSubview(dyteView)
                            dyteView.join(config);
                            self.tabBarController?.tabBar.isHidden = true
                        }
                    } catch {
                        self.errorMessage.text = "Unable to join or load meeting view"
                        self.errorMessage.isHidden = false
                    }
                }
                participantRequest.resume()
            } catch {
                self.errorMessage.text = "Can't Create Meeting"
                self.errorMessage.isHidden = false
            }
        }
        task.resume()
    }
    
    @IBAction func startMeeting(_ sender: Any) {
        noErrors()
        if hostName.text == "" {
            errorMessage.text = "User name can't be empty"
            errorMessage.isHidden = false
            hostName.layer.borderWidth = 2.0
            hostName.layer.borderColor = UIColor.red.cgColor
            return
        } else {
            createMeeting()
        }
    }
    
    
    
    fileprivate func onMeetingEnded() {
        if let viewWithTag = self.view.viewWithTag(100) {
            self.tabBarController?.tabBar.isHidden = false
            viewWithTag.removeFromSuperview()
        }
    }
}

extension CreateMeetingViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateMeetingViewController: DyteMeetingViewDelegate {
    func meetingEnded() {
        DispatchQueue.main.async { [weak self] in
            self?.onMeetingEnded()
        }
    }
}


