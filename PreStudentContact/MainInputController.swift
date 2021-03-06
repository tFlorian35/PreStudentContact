//
//  ViewController.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import UIKit
import Foundation


extension String{
  func cleanPonctuation() -> String {
    var newString = self.replacingOccurrences(of: ",", with: " ", options: NSString.CompareOptions.literal, range: nil)
    newString = newString.replacingOccurrences(of: "'", with: " ", options: NSString.CompareOptions.literal, range: nil)
    newString = newString.replacingOccurrences(of: "\"", with: " ", options: NSString.CompareOptions.literal, range: nil)
    newString = newString.replacingOccurrences(of: "$", with: " ", options: NSString.CompareOptions.literal, range: nil)
    newString = newString.replacingOccurrences(of: "&", with: " ", options: NSString.CompareOptions.literal, range: nil)
    newString = newString.replacingOccurrences(of: ";", with: " ", options: NSString.CompareOptions.literal, range: nil)
    return newString
  }
  
}


class MainInputController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
  
  var myPasswordDelete = "Forum2016"
  var myListOfClassesOptions = [["--------","Première", "Seconde", "Terminale"],
    ["--------","S","ES", "L", "STI","STI2D","STI2A", "STAV", "STG", "STT", "STI","STMG", "PRO", "DAEU", "BAC étranger"]]
  
  let myKeyboardShift = CGFloat(-70.0)
  var myTabEtudians = [Etudiant]()
  var myIsEditing = true
  let myColorActive = UIColor.white
  let myColorInActive = UIColor.lightGray
  let myColorBGViewActive = UIColor(colorLiteralRed: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
  let myColorBGViewInActive = UIColor(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
  var myCurrentDisplayStudent = 0
  var myIsInHistory = false
  var myCurrentStudent: Etudiant?
  var myEmailExport : String?
  var myForumName: String = "ForumNoName"
  var myDate: String?
  var myDateM1: String?
  var myHistoryMode: Bool = false
  var myInterfaceIsShifted: Bool = false
  
  @IBOutlet var myInterfaceView: UIView!
  @IBOutlet var myNameField: UITextField!
  @IBOutlet weak var myLastNameField: UITextField!
  @IBOutlet weak var myOptionField: UITextField!
  
  @IBOutlet weak var myClassePickView: UIPickerView!
  @IBOutlet weak var myHeureCreation: UILabel!
  
  @IBOutlet weak var myInscriptionDateLabel: UILabel!
  @IBOutlet weak var myForumLabel: UILabel!
  @IBOutlet weak var myIdStudent: UILabel!
  @IBOutlet weak var myTotalSaved: UILabel!
  @IBOutlet weak var myTotalSavedDay: UILabel!
  @IBOutlet weak var myTotalSaveDayM1: UILabel!
  @IBOutlet weak var myScoreLabelInfo: UILabel!
  @IBOutlet weak var myScoreLabelGEII: UILabel!
  @IBOutlet weak var myScoreLabelMMI: UILabel!
  
  @IBOutlet weak var myTownField: UITextField!
  @IBOutlet weak var myEmailField: UITextField!
  @IBOutlet weak var myPhoneField: UITextField!
  @IBOutlet weak var mySaveButton: UIButton!
  @IBOutlet weak var myDeptField: UITextField!
  var myPasswordTextField: UITextField?
  
  @IBOutlet weak var myEditButton: UIButton!
  @IBOutlet weak var myPrecButton: UIButton!
  @IBOutlet weak var mySuivButton: UIButton!
  @IBOutlet weak var mySaveModifs: UIButton!
  @IBOutlet weak var myCancelButton: UIButton!
  
  @IBOutlet weak var myDeleteButton: UIButton!
  
  @IBOutlet weak var myHistoryButton: UIButton!
  @IBOutlet weak var myDUTInfoButton: UIButton!
  @IBOutlet weak var myDUTGeiiButton: UIButton!
  @IBOutlet weak var myDUTMiiButton: UIButton!
  
  @IBOutlet weak var myLPIsnButton: UIButton!
  @IBOutlet weak var myLPI2mButton: UIButton!
  @IBOutlet weak var myLPA2iButton: UIButton!
  @IBOutlet weak var myLPAtcTecamButton: UIButton!
  @IBOutlet weak var myLPAtcCdgButton: UIButton!
  
  @IBOutlet weak var myNewsLetterButton: UIButton!
  
  var myIsDUTInfoSel: Bool = false
  var myIsDUTGeiiSel: Bool = false
  var myIsDUTMiiSel: Bool = false
  var myIsLPIsnSel: Bool = false
  var myIsLPI2mSel: Bool = false
  var myIsLPA2iSel: Bool = false
  var myIsLPAtcTecamSel: Bool = false
  var myIsLPAtcCdgSel: Bool = false
  var myIsNewLetterSel: Bool = true
  
  func getIndex(_ aName: String)-> Int?{
    //searching index
    for list in  myListOfClassesOptions {
      var pos = 0
      for n in list {
        if n == aName {
          return pos
        }
        pos += 1
      }
    }
    
    return nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapReco = UITapGestureRecognizer(target: self, action: #selector(MainInputController.dismissKeyboard))
    self.view.addGestureRecognizer(tapReco)
    loadDate()
    
    
    // Recover the tab of all students:
    myClassePickView.dataSource = self
    myClassePickView.delegate = self
    myCurrentStudent = Etudiant(aName: "--", aLastName: "--", aClass: "--", aSpe: "--", aTown: "--",
      aForumInscription: myForumName, aDateInscription: myDate!)
    myCurrentStudent?.myLPProject = [String]()
    myCurrentStudent?.myDUTProject = [String]()
    
    updateStudent(myCurrentStudent!)
    myNameField.delegate = self
    myLastNameField.delegate = self
    myOptionField.delegate = self
    myTownField.delegate = self
    myPhoneField.delegate = self
    myDeptField.delegate = self
    myEmailField.delegate = self
    
    let sharedDefault = UserDefaults.standard
    myForumName = sharedDefault.object(forKey: "FORUM_NAME") as! String
    myTabEtudians = recoverTableauEtudiant(myForumName)
    myInscriptionDateLabel.text = myDate
    updateInterfaceState()
    updateDisplayWithEtudiant(myCurrentStudent!)
    myForumLabel.text = myForumName
    
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func loadPrevious(_ sender: UIButton) {
    if myCurrentDisplayStudent == 0 {
      updateStudent(myCurrentStudent!)
    }
    if myCurrentDisplayStudent != myTabEtudians.count  {
      myCurrentDisplayStudent += 1
    }
    myIsEditing = false
    updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
    updateInterfaceState()
  }
  
  @IBAction func loadNext(_ sender: AnyObject) {
    if myCurrentDisplayStudent == 0 {
      return
    }
    
    if myCurrentDisplayStudent != 1{
      myCurrentDisplayStudent -= 1
      myIsEditing = false
      updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
      myEditButton.isHidden = false
      myCancelButton.isHidden = false
      mySaveButton.isHidden = true
    }else{
      myCurrentDisplayStudent -= 1
      myIsEditing = true
      updateDisplayWithEtudiant(myCurrentStudent!)
    }
    updateInterfaceState()
  }
  
  
  func loadDate(){
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "dd_MM_yyyy"
    
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let dateM1 = (calendar as NSCalendar?)?.date(byAdding: NSCalendar.Unit.day, value: -1, to: Date(), options: NSCalendar.Options())
    
    myDate =  "\(dateFormater.string(from: Date()))"
    myDateM1 =  "\(dateFormater.string(from: dateM1!))"
    
    
  }
  
  func updateStudent(_ aStudent: Etudiant){
    aStudent.myName = myNameField.text!.cleanPonctuation()
    aStudent.myLastName = myLastNameField.text!.cleanPonctuation()
    aStudent.myClass = myListOfClassesOptions[0][myClassePickView.selectedRow(inComponent: 0)]
    aStudent.mySpe = myListOfClassesOptions[1][myClassePickView.selectedRow(inComponent: 1)]
    aStudent.myTown = myTownField.text!.cleanPonctuation()
    if myDeptField.text != ""{
      aStudent.myDept = (Int) (NSString(string: myDeptField.text!).intValue)
    }
    aStudent.myEmail = myEmailField.text!.cleanPonctuation()
    aStudent.myTel = myPhoneField.text!.cleanPonctuation()
    aStudent.myDUTProject?.removeAll()
    aStudent.myLPProject?.removeAll()
    
    if myIsDUTInfoSel {
      aStudent.myDUTProject?.append("DUT INFO")
    }
    if myIsDUTGeiiSel {
      aStudent.myDUTProject?.append("DUT GEII")
    }
    if myIsDUTMiiSel {
      aStudent.myDUTProject?.append("DUT MMI")
    }
    if myIsLPIsnSel {
      aStudent.myLPProject?.append("LP ISN")
    }
    if myIsLPI2mSel {
      aStudent.myLPProject?.append("LP I2M")
    }
    if myIsLPA2iSel {
      aStudent.myLPProject?.append("LP A2I")
    }
    if myIsLPAtcCdgSel {
      aStudent.myLPProject?.append("LP ATC/CDG")
    }
    if myIsLPAtcTecamSel {
      aStudent.myLPProject?.append("LP ATC/TECAMTV")
    }
    aStudent.myNewsLetter = myIsNewLetterSel
    aStudent.myDateInscription = myDate!
    aStudent.myForumInscription = myForumName
    aStudent.myOption = myOptionField.text
    
  }
  
  
  func eraseFields(){
    myNameField.text = ""
    myLastNameField.text = ""
    myTownField.text =  ""
    myEmailField.text = ""
    myPhoneField.text =  ""
    myOptionField.text = ""
    myDeptField.text = ""
    myIsLPAtcTecamSel = false
    myIsLPAtcCdgSel = false
    myIsLPI2mSel = false
    myIsLPIsnSel = false
    myIsLPA2iSel = false
    myIsDUTMiiSel = false
    myIsDUTInfoSel = false
    myIsDUTGeiiSel = false
    myIsNewLetterSel = true
    updateOrientationButtonState()
    myClassePickView.selectRow(0, inComponent: 0, animated: true)
    myClassePickView.selectRow(0, inComponent: 1, animated: true)
  }
  
  
  @IBAction func saveData(_ sender: UIButton) {
    updateStudent(myCurrentStudent!)
    addEtudiant(myCurrentStudent!)
    eraseFields()
    myCurrentStudent = Etudiant(other: myCurrentStudent!)
    myTabEtudians.append(Etudiant(other: myCurrentStudent!))
    updateStudent(myCurrentStudent!)
    updateDisplayWithEtudiant(myCurrentStudent!)
  }
  
  
  @IBAction func cancel(_ sender: AnyObject) {
    myIsEditing = false
    updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
    updateInterfaceState()
  }
  
  @IBOutlet weak var cancel: UIButton!
  //-----------------------
  // Processing display:
  
  
  
  func updateInterfaceState(){
    updateOrientationButtonState()
    updateScore()
    myClassePickView.isUserInteractionEnabled = myIsEditing
    myLastNameField.isEnabled = myIsEditing
    myNameField.isEnabled = myIsEditing
    myPhoneField.isEnabled = myIsEditing
    myTownField.isEnabled = myIsEditing
    myEmailField.isEnabled = myIsEditing
    myDeptField.isEnabled = myIsEditing
    myOptionField.isEnabled = myIsEditing
    myDUTMiiButton.isEnabled = myIsEditing
    myDUTInfoButton.isEnabled = myIsEditing
    myDUTGeiiButton.isEnabled = myIsEditing
    myLPIsnButton.isEnabled = myIsEditing
    myLPA2iButton.isEnabled = myIsEditing
    myLPAtcCdgButton.isEnabled = myIsEditing
    myLPAtcTecamButton.isEnabled = myIsEditing
    myNewsLetterButton.isEnabled = myIsEditing
    myLPI2mButton.isEnabled = myIsEditing
    
    let colorBg: UIColor = myIsEditing ? myColorActive : myColorInActive
    myLastNameField.backgroundColor = colorBg
    myNameField.backgroundColor = colorBg
    myPhoneField.backgroundColor = colorBg
    myTownField.backgroundColor = colorBg
    myEmailField.backgroundColor = colorBg
    myDeptField.backgroundColor = colorBg
    myOptionField.backgroundColor = colorBg
    mySaveButton.isHidden = !myIsEditing || myCurrentDisplayStudent != 0 || myHistoryMode || !checkOKSaving()
    myEditButton.isHidden = myCurrentDisplayStudent == 0
    
    myPrecButton.isHidden =  myCurrentDisplayStudent == myTabEtudians.count || myTabEtudians.count == 0 || !myHistoryMode
    mySuivButton.isHidden = myCurrentDisplayStudent <= 1 || myTabEtudians.count == 1 || !myHistoryMode
    myEditButton.isHidden = myIsEditing
    mySaveModifs.isHidden = !myIsEditing || myCurrentDisplayStudent == 0
    myCancelButton.isHidden = myCurrentDisplayStudent == 0 || !myIsEditing
    myDeleteButton.isHidden =  myCurrentDisplayStudent == 0 || !myIsEditing
    let colorBgView: UIColor = myIsEditing ? myColorBGViewActive : myColorBGViewInActive
    myInterfaceView.backgroundColor = colorBgView

  }
  
  
  func updateScore(){
    myTotalSavedDay.text = "\(getNumberStudentToday().0)"
    myTotalSaveDayM1.text = "\(getNumberStudentToday().1)"
    let score = getScore()
    myScoreLabelInfo.text = "INFO: \(score.0) (\(score.3))"
    myScoreLabelGEII.text = "GEII: \(score.1) (\(score.4))"
    myScoreLabelMMI.text = "MMI: \(score.2) (\(score.5))"
    myScoreLabelInfo.textColor = score.0 >= score.1 && score.0 >= score.2 ? UIColor.blue : UIColor.gray
    myScoreLabelGEII.textColor = score.1 >= score.0 && score.1 >= score.2 ? UIColor.blue : UIColor.gray
    
    myScoreLabelMMI.textColor = score.2 >= score.0 && score.2 >= score.1 ? UIColor.blue : UIColor.gray
    
    
    myScoreLabelInfo.textColor = score.3 >= score.4 && score.3 >= score.5 ? UIColor.blue : UIColor.gray
    myScoreLabelGEII.textColor = score.4 >= score.3 && score.4 >= score.5 ? UIColor.blue : UIColor.gray
    
    myScoreLabelMMI.textColor = score.5 >= score.3 && score.5 >= score.4 ? UIColor.blue : UIColor.gray
    
  }
  
  
  
  func updateDisplayWithEtudiant(_ unEtudiant: Etudiant){
    myNameField.text = unEtudiant.myName
    myLastNameField.text = unEtudiant.myLastName
    myTownField.text = unEtudiant.myTown
    myDeptField.text = unEtudiant.myDept == nil ? "" : "\(unEtudiant.myDept!)"
    myEmailField.text = unEtudiant.myEmail
    myPhoneField.text = unEtudiant.myTel
    myIdStudent.text = unEtudiant.myCreationDate
    myHeureCreation.text = unEtudiant.myHeureCreation
    myTotalSaved.text = "\(myTabEtudians.count)"
    let indexClass: Int? = getIndex(unEtudiant.myClass)
    let indexSpe: Int? = getIndex(unEtudiant.mySpe)
    myIsDUTMiiSel = unEtudiant.myDUTProject!.contains("DUT MMI")
    myIsDUTGeiiSel = unEtudiant.myDUTProject!.contains("DUT GEII")
    myIsDUTInfoSel = unEtudiant.myDUTProject!.contains("DUT INFO")
    
    myIsLPA2iSel = unEtudiant.myLPProject!.contains("LP A2I")
    myIsLPI2mSel = unEtudiant.myLPProject!.contains("LP I2M")
    myIsLPIsnSel = unEtudiant.myLPProject!.contains("LP ISN")
    myIsLPAtcCdgSel = unEtudiant.myLPProject!.contains("LP ATC/CDG")
    myIsLPAtcTecamSel = unEtudiant.myLPProject!.contains("LP ATC/TECAMTV")
    myIsNewLetterSel = unEtudiant.myNewsLetter
    myClassePickView.selectRow(indexClass != nil ? indexClass! : 0, inComponent: 0, animated: true)
    myClassePickView.selectRow(indexSpe != nil ? indexSpe! : 0, inComponent: 1, animated: true)
    myForumLabel.text = unEtudiant.myForumInscription
    myInscriptionDateLabel.text = unEtudiant.myDateInscription
    myOptionField.text = unEtudiant.myOption
    
    updateInterfaceState()
    updateOrientationButtonState()
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    updateInterfaceState()
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int{
    if pickerView.tag == 0
    {
      return 2
    }
    else
    {
      return 1
    }
  }
  
  func pickerView(_ pickerView: UIPickerView,
    numberOfRowsInComponent component: Int) -> Int{
      if pickerView.tag == 0
      {
        return myListOfClassesOptions[component].count
      }
      return 0
  }
  
  func pickerView(_ pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int) -> String?{
      if pickerView.tag == 0
      {
        return myListOfClassesOptions[component][row]
      }
      return "---"
  }
  
  
  @IBAction func edit(_ sender: AnyObject) {
    myIsEditing = true
    updateInterfaceState()
  }
  
  @IBAction func saveModifs(_ sender: AnyObject){
    myIsEditing = false
    updateStudent(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
    updateInterfaceState()
    saveListEtud(myTabEtudians)
  }
  
  func textFieldDidBeginEditing(_ textField : UITextField){
    
  }
  
  func textFieldShouldBeginEditing(){
    
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    updateInterfaceState()
    textField.resignFirstResponder()
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    NotificationCenter.default.addObserver(self, selector: #selector(MainInputController.keyboardDidShow),
      name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    return true
  }
  
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    NotificationCenter.default.addObserver(self, selector: #selector(MainInputController.keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    self.view.endEditing(true)
    return true
  }
  
  
  func keyboardDidShow()
  {
    if UIApplication.shared.statusBarOrientation.isLandscape {
      UIView.beginAnimations("registerScroll", context: nil)
      UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
      UIView.setAnimationDuration(0.2)
      self.view.transform = CGAffineTransform(translationX: 0, y: myKeyboardShift)
      UIView.commitAnimations()
      myInterfaceIsShifted = true
    }
  }
  
  
  func keyboardDidHide()
  {
    if myInterfaceIsShifted {
      UIView.beginAnimations("registerScroll", context: nil)
      UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
      UIView.setAnimationDuration(0.2)
      self.view.transform = CGAffineTransform(translationX: 0, y: 0)
      UIView.commitAnimations()
      myInterfaceIsShifted = false
    }
  }
  
  @IBAction func clickLPISN(_ sender: AnyObject) {
    myIsLPIsnSel = !myIsLPIsnSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickLPI2M(_ sender: AnyObject) {
    myIsLPI2mSel = !myIsLPI2mSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickLPA2I(_ sender: AnyObject) {
    myIsLPA2iSel = !myIsLPA2iSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickLPATCCDG(_ sender: AnyObject) {
    myIsLPAtcCdgSel = !myIsLPAtcCdgSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickTACTECAMTV(_ sender: AnyObject) {
    myIsLPAtcTecamSel = !myIsLPAtcTecamSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickDUTINFO(_ sender: AnyObject) {
    myIsDUTInfoSel = !myIsDUTInfoSel
    updateOrientationButtonState()
    
  }
  
  @IBAction func clickDUTGEII(_ sender: AnyObject) {
    myIsDUTGeiiSel = !myIsDUTGeiiSel
    updateOrientationButtonState()
    
  }
  
  @IBAction func clickDUTMMI(_ sender: AnyObject) {
    myIsDUTMiiSel = !myIsDUTMiiSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickNewsLetter(_ sender: AnyObject) {
    myIsNewLetterSel = !myIsNewLetterSel
    updateOrientationButtonState()
  }
  
  
  func updateOrientationButtonState(){
    myLPIsnButton.setImage(UIImage(named: myIsLPIsnSel ? "checked.png" : "unChecked.png"), for: UIControlState())
    myLPI2mButton.setImage(UIImage(named: myIsLPI2mSel ? "checked.png" : "unChecked.png"), for: UIControlState())
    myLPA2iButton.setImage(UIImage(named: myIsLPA2iSel ? "checked.png" : "unChecked.png"), for: UIControlState())
    myLPIsnButton.setImage(UIImage(named: myIsLPIsnSel ? "checked.png" : "unChecked.png"), for: UIControlState())
    myLPAtcCdgButton.setImage(UIImage(named: myIsLPAtcCdgSel ? "checked.png" : "unChecked.png"), for: UIControlState())
    myLPAtcTecamButton.setImage(UIImage(named: myIsLPAtcTecamSel ? "checked.png" : "unChecked.png"), for: UIControlState())
    myDUTInfoButton.setImage(UIImage(named: myIsDUTInfoSel ? "checked.png" : "unChecked.png"), for: UIControlState())
    myDUTGeiiButton.setImage(UIImage(named: myIsDUTGeiiSel ? "checked.png" : "unChecked.png"), for: UIControlState())
    myDUTMiiButton.setImage(UIImage(named: myIsDUTMiiSel ? "checked.png" : "unChecked.png"), for: UIControlState())
    myNewsLetterButton.setImage(UIImage(named: myIsNewLetterSel ? "checked.png" : "unChecked.png"), for: UIControlState())
  }
  
  
  func getNumberStudentToday() -> (Int, Int) {
    var resu: (Int, Int) = (0, 0)
    for etu in myTabEtudians {
      if etu.myDateInscription == myDate {
        resu.0 += 1
      }
      if etu.myDateInscription == myDateM1 {
        resu.1 += 1
      }
    }
    return resu
  }
  
  
  
  @IBAction func changeMode(_ sender: AnyObject) {
    if myTabEtudians.count >= 1 {
      myHistoryMode = !myHistoryMode
      myHistoryButton.setTitle(myHistoryMode ? "stop history" : "history" , for: UIControlState())
      if !myHistoryMode {
        myCurrentDisplayStudent = 0
        myIsEditing = true
        updateDisplayWithEtudiant(myCurrentStudent!)
      }else if myTabEtudians.count != 0{
        updateStudent(myCurrentStudent!)
        myCurrentDisplayStudent = 1
        myIsEditing = false
        updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
      }
      updateInterfaceState()
    }
  }
  
  
  func checkOKSaving() -> Bool {
    return myNameField.text != "" && myLastNameField.text != "" && myTownField.text != "" && myClassePickView.selectedRow(inComponent: 0) != 0 && myClassePickView.selectedRow(inComponent: 1) != 0;
  }
  
  
  
  @IBAction func deleteSudent(_ sender: AnyObject){
    let alert = UIAlertController(title: "pass needed", message: "enter password", preferredStyle: UIAlertControllerStyle.alert)
    alert.addTextField(configurationHandler: {(textField: UITextField!) in
      textField.placeholder = "Password"
      textField.isSecureTextEntry = true
      self.myPasswordTextField = textField
    })
    present(alert, animated: true, completion: nil)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: tryDeleteCurrentStudent))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
  }
  
  func deleteAll(){
    let alert = UIAlertController(title: "pass needed", message: "enter password", preferredStyle: UIAlertControllerStyle.alert)
    alert.addTextField(configurationHandler: {(textField: UITextField!) in
      textField.placeholder = "Password"
      textField.isSecureTextEntry = true
      self.myPasswordTextField = textField
    })
    present(alert, animated: true, completion: nil)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: tryDelete))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
  }
  
  func tryDelete(_ alert: UIAlertAction!){
    if myPasswordTextField!.text == myPasswordDelete {
      myTabEtudians.removeAll()
      saveListEtud(myTabEtudians)
      updateInterfaceState()
      updateDisplayWithEtudiant(myCurrentStudent!)
    }
  }
  
  func tryDeleteCurrentStudent(_ alert: UIAlertAction!){
    if myPasswordTextField!.text == myPasswordDelete {
      if myTabEtudians.count == 1 {
        myTabEtudians.remove(at: myTabEtudians.count - myCurrentDisplayStudent)
        myCurrentDisplayStudent = 0
        myIsEditing = true
        myHistoryMode = false
        myHistoryButton.setTitle("history" , for: UIControlState())
        
        updateDisplayWithEtudiant(myCurrentStudent!)
        updateInterfaceState()
        return
      }
      
      myTabEtudians.remove(at: myTabEtudians.count - myCurrentDisplayStudent)
      if myCurrentDisplayStudent != 1 {
        myCurrentDisplayStudent = myCurrentDisplayStudent - 1
      }
      saveListEtud(myTabEtudians)
      myIsEditing = false
      updateInterfaceState()
      updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent])
    }
    
  }
  
  func dismissKeyboard(){
    myNameField.resignFirstResponder()
    myLastNameField.resignFirstResponder()
    myOptionField.resignFirstResponder()
    myTownField.resignFirstResponder()
    myEmailField.resignFirstResponder()
    myDeptField.resignFirstResponder()
    myPhoneField.resignFirstResponder()
  }
  
  
  func getScore() -> (Int, Int, Int, Int, Int, Int)
  {
    var res = (0,0,0,0, 0, 0)
    for etu in myTabEtudians {
      if etu.myDateInscription == myDate || etu.myDateInscription == myDateM1 {
        var isInfo = false
        isInfo = etu.myDUTProject != nil &&  etu.myDUTProject!.contains("DUT INFO")
        isInfo = isInfo || (etu.myLPProject != nil && (etu.myLPProject!.contains("LP ISN") ||
          etu.myLPProject!.contains("LP I2M")))
        var isGeii = false
        isGeii = etu.myDUTProject != nil &&  etu.myDUTProject!.contains("DUT GEII")
        isGeii = isGeii || (etu.myLPProject != nil && (etu.myLPProject!.contains("LP A2I")))
        var isMmi = false
        isMmi = etu.myDUTProject != nil &&  etu.myDUTProject!.contains("DUT MMI")
        isMmi = isMmi || (etu.myLPProject != nil && (etu.myLPProject!.contains("LP ATC/TECAMTV") ||
          etu.myLPProject!.contains("LP ATC/CDG")))
        
        if etu.myDateInscription == myDate {
          res.0 += isInfo ? 1 : 0
          res.1 += isGeii ? 1 : 0
          res.2 += isMmi ? 1 : 0
          
        }else {
          res.3 += isInfo ? 1 : 0
          res.4 += isGeii ? 1 : 0
          res.5 += isMmi ? 1 : 0
          
        }
      }
    }
    return res
  }
  
  
}






