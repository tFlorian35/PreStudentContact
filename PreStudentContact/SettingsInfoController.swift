//
//  SettingsInfoController.swift
//  PreStudentContact
//
//  Created by kerautret on 14/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import UIKit
import MessageUI
import Foundation


class SettingsInfoController: UIViewController, MFMailComposeViewControllerDelegate{
  
  @IBOutlet weak var myMailField: UITextField!
  var myDefaultMailSubject = "liste participation forum"
  var myDefaultMailContent = "Bonjour, \n voilà la liste des inscrits... \n"
  
  @IBAction func sendFiles(sender: AnyObject) {
    let mailComposeViewController = configuredMailComposeViewController()
    if MFMailComposeViewController.canSendMail() {
      self.presentViewController(mailComposeViewController, animated: true, completion: nil)
    } else {
      self.showSendMailErrorAlert()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  
  func configuredMailComposeViewController() -> MFMailComposeViewController {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self
    mailComposerVC.setToRecipients([myMailField.text!])
    mailComposerVC.setSubject(myDefaultMailSubject)
    mailComposerVC.setMessageBody("", isHTML: false)
    let data: NSData? = exportListCSV()
    if data != nil {
      mailComposerVC.addAttachmentData(data!, mimeType: "csv", fileName: "listEtudiant.csv")
    }
    return mailComposerVC
  }
  
  
  func showSendMailErrorAlert() {
    let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email",
      message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",
      preferredStyle: UIAlertControllerStyle.Alert )
    self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    
  }

  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    controller.dismissViewControllerAnimated(true, completion: nil)
     print("errr")
  }
}