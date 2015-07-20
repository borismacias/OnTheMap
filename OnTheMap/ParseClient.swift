//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Boris Alexis Gonzalez Macias on 7/13/15.
//  Copyright (c) 2015 PropiedadFacil. All rights reserved.
//

import Foundation
import UIKit

class ParseClient: NSObject {
    
    var appID : String
    var apiKey : String
    let baseURL : String
    var session: NSURLSession
    var students : [StudentInformation]
    
    override init() {
        self.appID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        self.apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        self.baseURL = "https://api.parse.com/1/classes/"
        self.session = NSURLSession.sharedSession()
        self.students = []
        super.init()
    }
    
    
    
    func storeData(data:[[String:AnyObject]]){
        self.students = []
        for student in data{
            self.students.append(StudentInformation(data: student))
        }
    }
    
    // getting the student's data
    
    func getStudents(completionHandler: (success: Bool ,data: [String:AnyObject]) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let request = NSMutableURLRequest(URL: NSURL(string: "\(self.baseURL)StudentLocation")!)
        request.addValue("\(self.appID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(self.apiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                completionHandler(success: false, data: ["error": "\(error.localizedDescription)"])
                return
            }else{
                var error:NSError? = nil
                var parsedData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as! [String:AnyObject]
                completionHandler(success: true, data: parsedData )
            }
            
        }
        task.resume()
    }
    
    func postStudent(studentInfo : StudentInformation, mapString: String, completionHandler:(success:Bool, data:[String:AnyObject]) ->Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let uniqueKey = appDelegate.accountKey
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(studentInfo.firstName)\", \"lastName\": \"\(studentInfo.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(studentInfo.getURL())\",\"latitude\": \(studentInfo.lat), \"longitude\": \(studentInfo.lng)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, data: ["ErrorString":error.localizedDescription])
            }
            else{
                var error:NSError? = nil
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as! [String:AnyObject]
                println(jsonData)
                completionHandler(success: true, data : jsonData)
                
            }
        }
        task.resume()
    }
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}