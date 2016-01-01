//
//  OCRViewController.swift
//  UploadDemo
//
//  Created by FOX on 15/9/28.
//  Copyright © 2015年 mingchen'lab. All rights reserved.
//

import UIKit

class OCRViewController: UIViewController {
    
    
    var ocrDetail: ViewController?
    
    
    @IBOutlet weak var OCRlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        OCRlabel.text = ocrDetail?.ocrLabel.text
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
