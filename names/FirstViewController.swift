//
//  ViewController.swift
//  names
//
//  Created by Александра Сергеева on 28.09.2022.
//

import UIKit

enum NamesErrors: Error {
    case emptyNames
}

class FirstViewController: UIViewController {
    
    @IBOutlet weak var yourName: UITextField!
    @IBOutlet weak var partnerName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? ResultViewController else { return }
        destinationVC.firstName = yourName.text
        destinationVC.secondName = partnerName.text
    }
    
    @IBAction func resultButtonTapped() {
        let number = 4
        let doOnFailureFunc: () -> Void = {
            self.showAlert(
                title: "Names are missing",
                message: "Please enter both name☺️"
                )
        }
        
        do {
            try showResultsScreen(
                firstNameOpt: yourName.text,
                secondNameOpt: partnerName.text
            )
        } catch NamesErrors.emptyNames {
            doOnFailureFunc()
        } catch {
            doOnFailureFunc()
        }
    }
    
    
    func showResultsScreen(firstNameOpt: String?, secondNameOpt: String?) throws {
        
        guard let firstName = firstNameOpt, let secondName = secondNameOpt else {
            // not ok
            return
        }
        if firstName.isEmpty || secondName.isEmpty {
            throw NamesErrors.emptyNames
        } else {
            self.performSegue(withIdentifier: "goToResult", sender: nil)
        }
    }
    
    
    
    @IBAction func unwindSequeToFirstVC(seque: UIStoryboardSegue){
        yourName.text = ""
        partnerName.text = ""
    }
}

extension FirstViewController {
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}


extension FirstViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == yourName {
            partnerName.becomeFirstResponder()
        }
        else {
            resultButtonTapped()
        }
        return true
    }
}
