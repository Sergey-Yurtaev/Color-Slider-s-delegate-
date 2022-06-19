//
//  FirstViewController.swift
//  HW.2.2.1 Color Slider's
//
//  Created by Sergey Yurtaev on 24.11.2021.
//

import UIKit

protocol SecondViewControllerDelegate {
    func setColor (_ color: UIColor)
}

class FirstViewController: UIViewController {
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! SecondViewController
        secondVC.delegate = self
        secondVC.currentColor = view.backgroundColor
    }
    
    deinit {
        print("FirstViewController has been dealocated")
    }
}

// MARK: - ColorDelegate
extension FirstViewController: SecondViewControllerDelegate {
    func setColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}

