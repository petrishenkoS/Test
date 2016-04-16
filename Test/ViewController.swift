//
//  ViewController.swift
//  Test
//
//  Created by Admin on 13.04.16.
//  Copyright © 2016 Serhii Petrishenko. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signInButton(sender: AnyObject) {
        if isValidEmail(emailTextField.text!) && isValidPassword(passwordTextField.text!) {
            
            //let user = "iostestuser@gmail.com"
            //let password = "testuser"
            //не смог полность реализировать функцию логина, так как не знаю признаков успешной регистрации
            let plainString = "\(emailTextField.text!):\(passwordTextField.text!)" as NSString
            let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
            let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": "Basic " + base64String!]
            
            Alamofire.request(.GET, "https://promocode-app.com/api/v1/auth", parameters: [emailTextField.text!: passwordTextField.text!]).responseString {
                response in
                print(response.result.isSuccess)
                print(response.result.value)

            }
            
            
            //переход на main view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("mainTableViewController")
            self.presentViewController(vc, animated: true, completion: nil)
            
        } else {
            //pop up о некоректных данных
            let alertController = UIAlertController(title: nil, message: "Incorrect e-mail or password", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
    }
    
    //проверка на правильность ввода email
    func isValidEmail(str: String) -> Bool {
        
        let emailRegularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegularExpression)
        let result = emailTest.evaluateWithObject(str)
        return result
    }
    
    //проверка на правильность ввода password
    func isValidPassword(str: String) -> Bool {
        
        let passwordRegularExpression = "[A-Z0-9a-z]{4,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegularExpression)
        let result = passwordTest.evaluateWithObject(str)
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //убираем клавиатуру при нажатии
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //изменяем позиция контента в зависимости от поднятой-опущенной клавиатуры
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = -keyboardSize.height
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

