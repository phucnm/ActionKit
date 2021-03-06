//
//  ViewController.swift
//  ActionKit
//
//  Created by Kevin Choi, Benjamin Hendricks on 7/17/14.
//  Licensed under the terms of the MIT license
//

import UIKit
import ActionKit

class ViewController: UIViewController {
    
    // Test buttons used for our implementation of adding control events
    @IBOutlet var testButton: UIButton!
    @IBOutlet var testButton2: UIButton!
    @IBOutlet var testButton3: UIButton!
    @IBOutlet weak var tableTestButton: UIButton!
    
    // Test button used for a regular usage of target action without ActionKit
    @IBOutlet var oldTestButton: UIButton!
    
    // Test button used for setting and removing a control event
    @IBOutlet var inactiveButton: UIButton!
    
    // Part of making old test button changed to tapped. This is what ActionKit tries to avoid doing
    // by removing the need to explicitly declare selector functions when a closure is all that's needed
    @objc func tappedSelector(_ sender: UIButton!) {
        self.oldTestButton.setTitle("Old Tapped!", for: UIControlState())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //: ##Adding UIControl Events
        //:
        //: Old style of setting a target and action for the button
        oldTestButton.addTarget(self, action: #selector(ViewController.tappedSelector(_:)),
                                for: .touchUpInside)

        // This is equivalent to oldTestButton's implementation of setting the action to Tapped
        testButton.addControlEvent(.touchUpInside) {
            self.testButton.setTitle("Tapped!", for: .normal)
        }

        //: This adds a closure to the second button on the screen to change the text to Tapped2! when being tapped
        testButton2.addControlEvent(.touchUpInside, {
            self.testButton2.setTitle("Tapped2!", for: .normal)
        })

        //: This adds a closure, which receives the UIControl as input parameter, to the third button.
        //: It shows how the UIControl can be mapped to the UIButton, in order to have its title changed.
        testButton3.addControlEvent(.touchUpInside) { (control: UIControl) in
            guard let button = control as? UIButton else {
                return
            }
            let titleString: String? = "Tapped3!"
            button.setTitle(titleString, for: .normal)
        }

        //: The following shows that you can remove a control event that has been set.
        //: Initially, tapping the first button on the screen would set the text to "Tapped!" ...
        inactiveButton.addControlEvent(.touchUpInside) {
            self.inactiveButton.setTitle("Tapped!", for: .normal)
        }
        
        //: ... but then the following removes that.
        inactiveButton.removeControlEvent(.touchUpInside);

        
        //: #Adding GestureRecognizers
        //:
        //: Add a Tap Gesture Recognizer (tgr)
        let tgr = UITapGestureRecognizer("setRed") {
            self.view.backgroundColor = UIColor.red
        }
        
        //: The following three lines will add an additional action to the red color gesture recognizer.
        //:  Multiple actions per gesture recognizer (or control events) are possible.
        tgr.addClosure("setButton1") {
            self.testButton.setTitle("Gesture: tapped once!", for: .normal)
        }
        
        //: Add a Double Tap Gesture Recognizer (dtgr)
        let dtgr = UITapGestureRecognizer("setYellow") {
            self.view.backgroundColor = UIColor.yellow
        }
        dtgr.numberOfTapsRequired = 2
        
        //: These two gesture recognizers will change the background color of the screen.
        //: dtgr will make it yellow on a double tap,
        //: tgr makes it red on a single tap.
        view.addGestureRecognizer(dtgr)
        view.addGestureRecognizer(tgr)

        //: The following adds a long press gesture recognizer to the background view.
        //: It also shows it is not necessary to keep a reference to the gesture recognizer
        //: when you only need it inside the closure
        view.addGestureRecognizer(UILongPressGestureRecognizer() { (gesture: UIGestureRecognizer) in
            guard gesture is UILongPressGestureRecognizer else {
                return
            }
            if gesture.state == .began {
                let locInView = gesture.location(in: self.view)
                self.testButton2.setTitle("\(locInView)", for: .normal)
            }
        })
		
        // This adds a closure to the second button on the screen to change the text to Tapped2! when being tapped
        testButton2.addControlEvent(.touchUpInside, {
            self.testButton2.setTitle("Tapped2!", for: .normal)
        })
        
        // This shows that you can remove a control event that has been set. Originally, tapping the first button on the screen
        // would set the text to tapped! (line 31), but this removes that.
        testButton.removeControlEvent(.touchUpInside);
		
		// UIBarButton item
		let titleItem = UIBarButtonItem(title: "Press me") { 
			print("Title item pressed")
		}
		
		let image = UIImage(named: "alert")!
		let imageItem = UIBarButtonItem(image: image) { (item: UIBarButtonItem) in
			print("Item \(item) pressed")
		}
	
		let systemItem = UIBarButtonItem(barButtonSystemItem: .action) { 
			print("System item pressed")
		}
		
		self.navigationItem.rightBarButtonItems = [titleItem, imageItem, systemItem]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

