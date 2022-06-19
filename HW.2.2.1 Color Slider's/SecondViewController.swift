//
//  ViewController.swift
//  HW.2.2.1 Color Slider's
//
//  Created by Sergey Yurtaev on 30.10.2021.
//

import UIKit

class SecondViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var viewLabel: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    // MARK: - Public Properties
    var delegate: SecondViewControllerDelegate!
    var currentColor: UIColor!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLabel.layer.cornerRadius = 20
        viewLabel.backgroundColor = currentColor
        
        settingForViewDidLoad()
        setValueSliders(for: redSlider, greenSlider, blueSlider)
        setValueSliders(for: redLabel, greenLabel, blueLabel)
        setValueSliders(for: redTextField, greenTextField, blueTextField)
        addDoneButton(to: redTextField, greenTextField, blueTextField)
    }
    
    // MARK: - IB Actions
    @IBAction func rgbSliders(_ sender: UISlider) {
        
        switch sender.tag {
        case 0:
            setValueSliders(for: redLabel);
            setValueSliders(for: redTextField)
        case 1:
            setValueSliders(for: greenLabel);
            setValueSliders(for: greenTextField)
        case 2:
            setValueSliders(for: blueLabel);
            setValueSliders(for: blueTextField)
        default:
            break
        }
        
        getColorForView()
    }
    
    @IBAction func doneButton() {
        delegate?.setColor(viewLabel.backgroundColor ?? .red)
        dismiss(animated: true)
    }
    
    deinit {
        print("SecondViewController has been dealocated")
    }
}

// MARK: - Private Methods
extension SecondViewController {
    
    func getColorForView() {
        viewLabel.backgroundColor = UIColor(red: CGFloat(redSlider.value),
                                            green: CGFloat(greenSlider.value),
                                            blue: CGFloat(blueSlider.value),
                                            alpha: 1)
    }
    
    private func setValueSliders(for labels: UILabel...) {
        labels.forEach { label in
            switch label.tag {
            case 0: redLabel.text = string(from: redSlider)
            case 1: greenLabel.text = string(from: greenSlider)
            case 2: blueLabel.text = string(from: blueSlider)
            default:
                break
            }
        }
    }
    
    private func setValueSliders(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField.tag {
            case 0: redTextField.text = string(from: redSlider)
            case 1: greenTextField.text = string(from: greenSlider)
            case 2: blueTextField.text = string(from: blueSlider)
            default:
                break
            }
        }
    }
    
    private func setValueSliders(for sliders: UISlider...) {
        let ciColor = CIColor(color: currentColor)
        
        sliders.forEach { slider in
            switch slider.tag {
            case 0: redSlider.value = Float(ciColor.red)
            case 1: greenSlider.value = Float(ciColor.green)
            case 2: blueSlider.value = Float(ciColor.blue)
            default: break
            }
        }
    }
    
    private func settingForViewDidLoad() {
        redSlider.tintColor = .red
        greenSlider.tintColor = .green
        blueSlider.tintColor = .blue
        
        redLabel.textColor = .red
        greenLabel.textColor = .green
        blueLabel.textColor = .blue
        
        viewLabel.layer.cornerRadius = 20
    }
    
    // Value RGB
    private func string(from slider: UISlider) -> String {
        return String(format: "%.2f", slider.value)
    }
    
    // showAlert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // add a Done button to the numeric keypad
    private func addDoneButton(to textFields: UITextField...) {
        
        textFields.forEach { textField in
            let keyboardToolbar = UIToolbar()
            textField.inputAccessoryView = keyboardToolbar
            keyboardToolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title:"Done",
                                             style: .done,
                                             target: self,
                                             action: #selector(didTapDone))
            
            let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            
            keyboardToolbar.items = [flexBarButton, doneButton]
        }
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate
extension SecondViewController: UITextFieldDelegate {
    
    //Calls this function when the tap is recognized.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if let currentValue = Float(text) {
            switch textField.tag {
            case 0: redSlider.setValue(currentValue, animated: true)
                setValueSliders(for: redLabel)
            case 1: greenSlider.setValue(currentValue, animated: true)
                setValueSliders(for: greenLabel)
            case 2: blueSlider.setValue(currentValue, animated: true)
                setValueSliders(for: blueLabel)
            default:
                break
            }
            
            getColorForView()
        } else {
            textField.text = ""
            showAlert(title: "Wrong format", message: "Please enter correct value")
        }
    }
    
    // Limiting text length for textField
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if range.length + range.location > textField.text?.count ?? 0 {
            return false
        }
        let newLimit = (textField.text?.count)! + string.count - range.length
        return newLimit <= 4
    }
}


