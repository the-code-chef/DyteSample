import UIKit
import DyteSdk;

class ViewController: UIViewController {
//    @IBOutlet weak var videoButton: UIButton?
    fileprivate var dyteView: DyteMeetingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red;


    }
    
//    @IBAction func joinMeeting(_ sender: Any) {
//            	let  config = DyteMeetingConfig();
//                config.roomName = "hazel-mile";
//                let dyteView = DyteMeetingView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height:self.view.bounds.size.height ))
//                dyteView.delegate = self
//                dyteView.tag  = 100
//                self.dyteView = dyteView;
//                self.view.addSubview(dyteView)
//                dyteView.join(config);
//    }
    
    fileprivate func onMeetingEnded() {
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
}


extension ViewController: DyteMeetingViewDelegate {
    func meetingEnded() {
        DispatchQueue.main.async { [weak self] in
            self?.onMeetingEnded()
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


