//
//  ViewController.swift
//  WiFiConnect
//
//  Created by Jim Long on 3/12/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {

    var showPassword = false
    
    let appLabel: UILabel = {
        let label = UILabel()
        label.text = "Connect to WiFi"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    let ssidTextField: UITextField = {
        let tf = UITextField()
        tf.setDefaults()
        tf.placeholder = "SSID"
        tf.addTarget(self, action: #selector(handleEdittingText), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.setDefaults()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleEdittingText), for: .editingChanged)
        return tf
    }()
    
    let showPasswordButton: UIButton = {
        let button = UIButton(type: .system)

        button.sizeToFit()
        button.isEnabled = false
        button.isHidden = true

        button.setImage(#imageLiteral(resourceName: "ic_eye_closed").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .clear
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.addTarget(self, action: #selector(handleShowButtonPressed), for: .touchUpInside)

        return button
    }()
    
    let connectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connect", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleConnect), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupInputFields()
        
    }

    
    fileprivate func setupInputFields() {
        
        var topAnchor = NSLayoutYAxisAnchor()
        if #available(iOS 11, *) {
            topAnchor =  view.safeAreaLayoutGuide.topAnchor
            
        } else {
            topAnchor = topLayoutGuide.bottomAnchor
        }
        
        passwordTextField.rightView = showPasswordButton
        passwordTextField.rightViewMode = .unlessEditing
        showPasswordButton.isEnabled = true
        showPasswordButton.isHidden = false
        
        let stackView = UIStackView(arrangedSubviews: [appLabel, ssidTextField, passwordTextField, connectButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.anchor(top: topAnchor, left: view.leftAnchor,
                         bottom: nil, right: view.rightAnchor,
                         paddingTop: 80, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 180)
        
    }
    
    @objc
    func handleEdittingText() {
        guard
            let _ = ssidTextField.text,
            let _ = passwordTextField.text
            else {
                connectButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
                return
        }
        
        connectButton.isEnabled = true
        
        connectButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)

    }
    
    @objc
    func handleShowButtonPressed() {
        showPassword = !showPassword
        let icon = showPassword ? #imageLiteral(resourceName: "ic_eye_open") : #imageLiteral(resourceName: "ic_eye_closed")
        showPasswordButton.setImage(icon.withRenderingMode(.alwaysOriginal), for: .normal)
        passwordTextField.isSecureTextEntry = !showPassword
    }
    
    @objc
    func handleConnect() {
        
        guard
            let ssid = ssidTextField.text,
            let password = passwordTextField.text
            else {
                return
        }

        print("Connecting to SSID: \(ssid)")
        
        let config = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
        config.joinOnce = true
        
        NEHotspotConfigurationManager.shared.apply(config) { (error) in
            if let error = error {
                let errorString = self.getErrorString(error)
                let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            } else {
                let alert = UIAlertController(title: "Success", message: "Connected to SSID: \(ssid)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

    }

    func getErrorString(_ error : Error) -> String {
        let userInfo = (error as NSError).userInfo
        if let errorString = userInfo["NSLocalizedDescription"] as? String {
            return errorString
        } else {
            return "Invalid SSID and/or Password"
        }
    }

}

