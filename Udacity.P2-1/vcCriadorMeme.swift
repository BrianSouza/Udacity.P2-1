//
//  ViewController.swift
//  Udacity.P2-1
//
//  Created by Brian Diego De Souza on 11/10/2018.
//  Copyright © 2018 Array App. All rights reserved.
//

import UIKit

class vcCriadorMeme: UIViewController , UITextFieldDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    var txtAtivo: UITextField!
    var meme: Meme? = nil

    @IBOutlet weak var tbSup: UIToolbar!
    @IBOutlet weak var tbInfe: UIToolbar!
    @IBOutlet weak var txtTop: UITextField!
    @IBOutlet weak var txtBottom: UITextField!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var btnCompartilhar: UIBarButtonItem!
    @IBOutlet weak var pickImage: UIImageView!
    @IBOutlet weak var btnAlbum: UIBarButtonItem!
    @IBOutlet weak var btnCancelar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        definirEstilosTextFields(textField: txtTop, texto: "TOP")
        definirEstilosTextFields(textField: txtBottom, texto: "BOTTOM")
    }
    func definirEstilosTextFields(textField: UITextField,texto: String){
        let memeTextAttributes: [String: Any] = [
            NSAttributedStringKey.strokeWidth.rawValue: -3,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = NSTextAlignment.center
        //textField.text = texto
    }
    
    override func viewDidAppear(_ animated: Bool) {
        btnCompartilhar.isEnabled = ((pickImage.image?.hashValue) != nil)
    }
    
    func btnSelecionaImg(_ type: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func btnCameraClicked(_ sender: Any) {
        btnSelecionaImg(.camera)
    }
    @IBAction func btnAlbumClicked(_ sender: Any) {
        btnSelecionaImg(.photoLibrary)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalValue = info[UIImagePickerControllerOriginalImage] as? UIImage;
        pickImage.image = originalValue
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func compartilhar() {
        
        let memedImage = generateMemedImage()
        
        let compartilhar = UIActivityViewController(activityItems: [(memedImage)], applicationActivities:nil)
        
        compartilhar.completionWithItemsHandler = {(tipo: UIActivityType?,completo :Bool , itens: [Any]?, erro: Error?) in
            if completo{
                let meme = Meme(topo: self.txtTop.text!, bottom: self.txtBottom.text!, imgOriginal: self.pickImage.image!, imgNova: memedImage)
                
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(meme)
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(compartilhar, animated: true, completion: nil)
    }
    func esconderToolBars(_ esconder: Bool){
        tbSup.isHidden = esconder
        tbInfe.isHidden = esconder
    }
    
    func generateMemedImage() -> UIImage {
        esconderToolBars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        esconderToolBars(false)
        
        return memedImage
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        txtAtivo = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtAtivo = nil
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
        if txtAtivo == txtBottom{
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    @IBAction func cancelar(_ sender: Any) {
        pickImage.image = nil
        txtTop.text = ""
        txtBottom.text = ""
        btnCompartilhar.isEnabled = ((pickImage.image?.hashValue) != nil)
        self.dismiss(animated: true, completion: nil)
    }
}

