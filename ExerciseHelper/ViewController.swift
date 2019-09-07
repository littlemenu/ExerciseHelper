//
//  ViewController.swift
//  ExerciseHelper
//
//  Created by 정재훈 on 04/09/2019.
//  Copyright © 2019 정재훈. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var cleanButton: UIButton!
    
    var speechUtterance: AVSpeechUtterance = AVSpeechUtterance()
    let speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    var timer: Timer = Timer()
    var countSet: Int = 0
    var setQuantity: Int = 0
    var setSecond: Int = 0
    var nowQuantity: Int = 0
    var nowSecond: Int = 0
    var isSpeaking: Bool = false
    var isStarting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setOutletAttributes()
    }

    @IBAction func touchUpStartButton(_ sender: UIButton) {
        if isSpeaking {
            print("실행중")
            return
        }
        
        guard let Quantity: Int = Int(quantityTextField.text!) else {
            callAlertAction("횟수 입력 값이 숫자가 아님")
            return
        }
        
        guard let Second: Int = Int(secondTextField.text!) else {
            callAlertAction("초 입력 값이 숫자가 아님")
            return
        }
        
        if Quantity == 0 || Second == 0 {
            callAlertAction("0이 입력됨")
            return
        }
        
        isStarting = true
        isSpeaking = true
        setQuantity = Quantity
        setSecond = Second
        speechSynthesizer.stopSpeaking(at: .immediate)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(oneSecondTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func touchUpPauseButton(_ sender: UIButton) {
        
        if isStarting {
            if isSpeaking {
                pauseButton.setTitle("Countinue", for: .init())
                speechSynthesizer.pauseSpeaking(at: .word)
                timer.invalidate()
                
            } else {
                pauseButton.setTitle("Pause", for: .init())
                speechSynthesizer.continueSpeaking()
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(oneSecondTimer), userInfo: nil, repeats: true)
            }
            isSpeaking = !isSpeaking
        }
    }
    
    @IBAction func touchUpCleanButton(_ sender: UIButton) {
        isStarting = false
        isSpeaking = false
        timer.invalidate()
        speechSynthesizer.stopSpeaking(at: .immediate)
        countSet = 0
        setQuantity = 0
        setSecond = 0
        nowQuantity = 0
        nowSecond = 0
        setOutletAttributes()
    }
    
    @objc func oneSecondTimer() {
        nowSecond += 1
        
        if (setQuantity == nowQuantity) {
            timer.invalidate()
            speechSynthesizer.stopSpeaking(at: .word)
            nowSecond = 0
            nowQuantity = 0
            countSet += 1
            setLabel.text = "\(countSet) 세트"
            isStarting = false
            isSpeaking = false
            return
        }
        
        if (setSecond < nowSecond) {
            nowQuantity += 1
            nowSecond = 0
            print(nowQuantity)
        } else {
            speechUtterance = AVSpeechUtterance(string: "\(nowSecond)")
            setTTSAttributes()
            speechSynthesizer.speak(speechUtterance)
        }
    }
    
    func setOutletAttributes() {
        setLabel.text = "\(countSet) 세트"
        quantityTextField.keyboardType = .numberPad
        quantityTextField.text?.removeAll()
        quantityTextField.placeholder = "운동 횟수"
        quantityTextField.textAlignment = .right
        secondTextField.keyboardType = .numberPad
        secondTextField.text?.removeAll()
        secondTextField.placeholder = "횟수당 초"
        secondTextField.textAlignment = .right
        startButton.setTitle("Start", for: .init())
        pauseButton.setTitle("Pause", for: .init())
        cleanButton.setTitle("Clean", for: .init())
        cleanButton.setTitleColor(.red, for: .init())
    }
    
    func setTTSAttributes() {
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        speechUtterance.rate = 0.35
    }
    
    func callAlertAction(_ alertMessage: String) {
        let alertController: UIAlertController = UIAlertController(title: "실행 실패!", message: alertMessage, preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "네", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
