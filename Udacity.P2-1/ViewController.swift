//
//  ViewController.swift
//  Udacity.P2-1
//
//  Created by Brian Diego De Souza on 11/10/2018.
//  Copyright © 2018 Array App. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate  {

    
    @IBOutlet weak var tbSup: UIToolbar!
    @IBOutlet weak var tbInfe: UIToolbar!
    @IBOutlet weak var txtTOP: UITextField!
    @IBOutlet weak var txtBOTTOM: UITextField!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var btnCompartilhar: UIBarButtonItem!
    @IBOutlet weak var pickImage: UIImageView!
    @IBOutlet weak var btnAlbum: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtTOP.delegate = self
        txtBOTTOM.delegate = self
        
        let memeTextAttributes: [String: Any] = [NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
                                                 NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
                                                 NSAttributedStringKey.strokeWidth.rawValue: 1,
                                                 NSAttributedStringKey.font.rawValue:UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        ]
        
        txtTOP.defaultTextAttributes = memeTextAttributes
        txtTOP.textAlignment = NSTextAlignment.center
        txtTOP.text = "TOP"
        
        txtBOTTOM.defaultTextAttributes = memeTextAttributes
        txtBOTTOM.textAlignment = NSTextAlignment.center
        txtBOTTOM.text = "BOTTOM"
        
    }
    override func viewDidAppear(_ animated: Bool) {
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        btnCompartilhar.isEnabled = ((pickImage.image?.hashValue) != nil)
    }

    @IBAction func btnCameraClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func btnAlbumClicked(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalValue = info[UIImagePickerControllerOriginalImage] as? UIImage;
        pickImage.image = originalValue
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save() {
        let memedImage = generateMemedImage()
        let meme = Meme(topo: txtTOP.text!, bottom: txtBOTTOM.text!, imgOriginal: pickImage.image!, imgNova: memedImage)
        
        let compartilhar = UIActivityViewController(activityItems: [(meme.imgNova)], applicationActivities:nil)
        
        self.present(compartilhar, animated: true, completion: nil)
    }
    func generateMemedImage() -> UIImage {
        
        tbSup.isHidden = true
        tbInfe.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        tbSup.isHidden = false
        tbInfe.isHidden = false
        
        return memedImage
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtTOP{
            txtTOP.text = ""
        }
        if textField == txtBOTTOM{
            txtBOTTOM.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
}

