//
//  ToolsInOut.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import Foundation

func addEtudiant(unEtudiant: Etudiant){
  if let path = NSBundle.mainBundle().pathForResource("listeEtudiants", ofType: "plist") {
    if var listeEtudiant = NSDictionary(contentsOfFile: path) as? Dictionary<String,  Dictionary<String, AnyObject > > {

      var dicoEtu = Dictionary<String, AnyObject > ()
      dicoEtu["name"] = unEtudiant.myName
      dicoEtu["lastName"] = unEtudiant.myLastName
      dicoEtu["classe"] = unEtudiant.myClass
      dicoEtu["specialite"] = unEtudiant.mySpe
      dicoEtu["town"] = unEtudiant.myTown
      dicoEtu["dept"] = unEtudiant.myDept
      dicoEtu["email"] = unEtudiant.myEmail
      dicoEtu["numTel"] = unEtudiant.myTel
      dicoEtu["integrationDUT"] = unEtudiant.myDUTProject
      dicoEtu["integrationLP"] = unEtudiant.myLPProject
      
      listeEtudiant["\(unEtudiant.hash)"] = dicoEtu
      (listeEtudiant as NSDictionary).writeToFile(path, atomically: true)
    }
  }
    
}
  


func recoverTableauEtudiant() ->[Etudiant] {
  var tabResu = [Etudiant]()
  if let path = NSBundle.mainBundle().pathForResource("listeEtudiants", ofType: "plist") {
    if let listeEtudiant = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject > {
      for (_, etu) in listeEtudiant {
        let name = etu["name"]! as! String
        let lastName = etu["lastName"]! as! String
        let classe = etu["classe"]! as! String
        let specialite = etu["specialite"]! as! String
        let town = etu["town"]! as! String
        let dept = etu["dept"]! as? Int
        let email = etu["email"] as? String
        let integrationDUT = etu["integrationDUT"] as? String
        let integrationLP = etu["integrationLP"] as? String
        let etudiant = Etudiant(aName: name, aLastName: lastName, aClass: classe, aSpe: specialite, aTown: town)
        if email != nil
        {
          etudiant.myEmail = email
        }
        if dept != nil
        {
          etudiant.myDept = dept
        }
        if integrationDUT != nil
        {
          etudiant.myDUTProject = integrationDUT
        }
        if integrationLP != nil  {
          etudiant.myLPProject   = integrationLP
        }
        tabResu.append(etudiant)
      }
    }
  }
  return tabResu
  
}




