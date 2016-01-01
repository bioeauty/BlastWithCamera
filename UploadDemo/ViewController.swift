//
//  ViewController.swift
//  UploadDemo
//
//  Created by FOX on 15/8/22.
//  Copyright (c) 2015年 mingchen'lab. All rights reserved.
//

import UIKit
import SwiftyJSON


class ViewController: UIViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, UIPopoverControllerDelegate,NSURLSessionDataDelegate{
    
  
    
    @IBOutlet var myView: UIView!
    
    @IBOutlet weak var TitleLobel: UILabel!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    @IBOutlet weak var btnClickMe: UIButton!
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var imageUploadProgressView: UIProgressView!
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var progressLable: UILabel!
    @IBOutlet weak var ocrLabel: UILabel!
    
  
    
    @IBAction func uploadButtonTapped(sender: AnyObject) {
        if myImageView.image == nil {
            print("keep")
        } else {
        myImageUploadRequest()
    }
    }

    
    @IBAction func btnImagePickerClicked(sender: AnyObject)
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(btnClickMe.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
        func openGallary() {
//        var myPickerController = UIImagePickerController()
//            myPickerController.delegate = self;
//            myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//            self.presentViewController(myPickerController, animated: true, completion: nil)

            
            picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone
            {
                self.presentViewController(picker!, animated: true, completion: nil)
            }
            else
            {
                popover=UIPopoverController(contentViewController: picker!)
                popover!.presentPopoverFromRect(btnClickMe.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
        
    {
        myImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
        let currentImage = myImageView.description
        print("\(myImageView.image?.decreaseSize)")
    }
    
    
  
    
    
    func myImageUploadRequest()
    {
        
        let myUrl = NSURL(string: "http://www.ibiocube.com/app/ocr.php");
        
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        request.timeoutInterval = 180;
        
        let param = [
            "firstName"  : "Yincong",
            "lastName"    : "Zhou",
            "userId"    : "9"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(myImageView.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        
//        myActivityIndicator.startAnimating();
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
         
            
        
            // You can print out response object
//            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            print("\(responseString)")
            
//            print("****** response data = \(responseString!)")
           
            self.TitleLobel.textColor = UIColor.blackColor()
          
          if  let json = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            {
            let jsonresult = JSON(json)
            
             let message = jsonresult["content"].stringValue
        
            
    
            print("fox")
            print("\(message)")
            print("fox")
            self.ocrLabel.text = message
            
            
             
            
            }
            
            dispatch_async(dispatch_get_main_queue(),{
//                self.myActivityIndicator.stopAnimating()
                self.myImageView.image = nil;
            });
            
           
//            if let parseJSON = json {
//            var firstNameValue = parseJSON["firstName"] as? String
//            println("firstNameValue: \(firstNameValue)")
//            }
            
            
        }
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let task1 = session.uploadTaskWithRequest(request, fromData: imageData!)
        
        task.resume()
        task1.resume()
        

        
        
        
        
        
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "\(strNowTime).jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
    {
        print("didCompleteWithError")
        
        let myAlert = UIAlertView(title: "Alert", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Ok")
        myAlert.show()
        
        self.uploadButton.enabled = true
        
    }
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
        print("didSendBodyData")
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        
        imageUploadProgressView.progress = uploadProgress
        let progressPercent = Int(uploadProgress*100)
        progressLable.text = "\(progressPercent)%"
        print(uploadProgress)
        upload_checked()
    }
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void)
    {
        print("didReceiveResponse")
        print(response);
        self.uploadButton.enabled = true
    }
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData)
    {
        print("didReceiveData")
    }
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func upload_checked() {
        if(progressLable.text == "100%") {
            progressLable.text = "OK"
        }
    }
        override func viewDidLoad() {
            super.viewDidLoad()
            TitleLobel.textColor = UIColor.whiteColor()
            
//           let localNotification: UILocalNotification = UILocalNotification()
//            localNotification.alertAction = "Testing notifications on iOS8"
//                            localNotification.alertBody = "what a lovely day"
//            localNotification.fireDate = NSDate(timeIntervalSinceNow: 60)
//            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            self.myView.addSubview(myScrollView)
        
            
            self.myScrollView.addSubview(ocrLabel)
                    }
    
}



extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    





