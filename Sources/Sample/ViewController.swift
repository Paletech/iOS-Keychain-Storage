//
//  ViewController.swift
//  bbb
//
//  Created by LEMIN DAHOVICH on 01.03.2023.
//

import Sample
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sampleManager = SampleManager()
        
        //Storing a string in the keychain:
        sampleManager.setString("hello")
        
        //Retrieving a string from the keychain:
        print(sampleManager.getString()!) //prints: hello

        //Storing a boolean value in the keychain:
        sampleManager.setBool(true)
        
       //Retrieving a boolean value from the keychain:
        print(sampleManager.getBool()!) //prints: true

        //Deleting a keychain item:
        print(sampleManager.delete("Example1")) //prints: true
        
        //Retrieving all keys in service:
        print(sampleManager.allKeys())  //prints: ["Example4", "Example2"]
        
        //Clear all data in service:
        print(sampleManager.clear()) //prints: true
    }
    
    deinit {
        print("DEINIT")
    }
}
