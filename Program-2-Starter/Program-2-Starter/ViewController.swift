//
//  ViewController.swift
//  Program-2-Starter
//
//  Created by Terry Griffin on 3/23/15.
//  Copyright (c) 2015 mwsu. All rights reserved.
//

import UIKit

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

class ViewController: UIViewController , ColorTableViewControllerDelegate{
    
    // MARK: - Declarations
    
    var myColors:Colors = Colors()
    
    @IBOutlet weak var chosenColorLabel: UILabel!
    @IBOutlet weak var colorItemsLabel: UILabel!
    
    @IBOutlet weak var RGBlabelval: UILabel!
    @IBOutlet weak var HSLlabelval: UILabel!
    @IBOutlet weak var HSVlabelval: UILabel!
    @IBOutlet weak var Colorlebel1: UILabel!
    @IBOutlet weak var Colorlabel2: UILabel!
    @IBOutlet weak var Colorlabel3: UILabel!
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        
        request(.GET, "http://cs.mwsu.edu/~griffin/swift/colors2.json")
            
            //Fetch the Json color object from the CS server
            //request(.GET, "https://raw.githubusercontent.com/rugbyprof/msu-swift/master/Program-1-Starter/Program_1_Starter/colors.json?token=AA_qiGlSkC9fWHXsmC732qc3XWl-aKqlks5VFkCWwA%3D%3D")
            
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    println("Error: \(error)")
                    println(req)
                    println(res)
                } else {
                    
                    println("Success")
                    
                    //Unwrap the json (not safe, but oh well)
                    var json = JSON(json!)
                    
                    //If we are successful, then call the method `parseJson` to load the "color class: Colors"
                    self.parseJson(json)
                    
                }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        //if the segue matches a specific identifier
        if (segue.identifier == "colorSegue") {
            
            // create a "reference" to that controller (in this case the Navigation Controller)
            let navVC = segue.destinationViewController as! UINavigationController
            
            //Since our ColorTableViewController is embedded in the Navigation Controller, we
            //need to create a reference to it
            let tableVC = navVC.viewControllers.first as! ColorTableViewController
            
            //Set the "myColors" variable in the table view with our local class value
            tableVC.myColors = myColors
            
            //Tell the "tableVC" (of type ColorTableViewController in this case)
            //that it's delegate will be "self"
            tableVC.delegate = self
        }
        
        //Here is a slightly different way to do the same thing
        //        if segue.identifier == "colorSegue" {
        //            let navVC = segue.destinationViewController as UINavigationController
        //            let tableVC = navVC.topViewController as ColorTableViewController
        //            tableVC.myColors = myColors
        //            tableVC.delegate = self
        //        }
    }
    
    
    // MARK: - Protocol Implementation
    
    func ColorTableViewChooseColorCancel(controller:ColorTableViewController){
        dismissViewControllerAnimated(true, completion: nil)
        println("choose cancel")
    }
    
    func ColorTableViewChooseColor(controller: ColorTableViewController, chosenColor color: String){
        dismissViewControllerAnimated(true, completion: nil)
        Colorlebel1.text = ""
        Colorlabel2.text = ""
        Colorlabel3.text = ""
        Colorlabel3.backgroundColor = Colorlabel2.backgroundColor
        Colorlabel2.backgroundColor = Colorlebel1.backgroundColor
        let labelColor:UIColor = myColors.hexStringToUIColor(myColors.fetchHexValue(color))
        chosenColorLabel.backgroundColor = labelColor
        Colorlebel1.backgroundColor = chosenColorLabel.backgroundColor
        colorItemsLabel.text = color
        
        let rgb = myColors.fetchRGB(color)
        let r = Float(255*rgb.R)
        let g = Float(255*rgb.G)
        let b = Float(255*rgb.B)
        RGBlabelval.text = "RGB: \(r), \(g), \(b)"
        let hsl = myColors.fetchHSL(color)
        HSLlabelval.text = "HSL: \(hsl.H), \(hsl.S), \(hsl.L)"
        let hsv = myColors.fetchHSV(color)
        HSVlabelval.text = "HSV: \(hsv.H), \(hsv.S), \(hsv.V)"
        
        println("red: \(r)")
        
        println(labelColor)
    }
    
    /********************************************************************************************
    * Function: parseJson
    *   Parses json object and loads it into the "Colors" class for us to use.
    * @Params:
    *   json:JSON - Json object to be parsed
    * @Returns:
    *   Void
    ********************************************************************************************/
    func parseJson(json:JSON)->Void{
        
        var colors = Colors()
        var colorName = ""
        var hexValue = ""
        var hsv:HSV
        var hsl:HSL
        var rgb:RGB
        var col = ""
        var hex = ""
        var r = 0.0
        var g = 0.0
        var b = 0.0
        var h1 = 0
        var s1 = 0.0
        var h2 = 0
        var s2 = 0.0
        var l = 0.0
        var v = 0.0
        
        
        for (index,subjson) in json {
            for (key,val) in subjson {
                switch key {
                case "colorName":
                    col = val.stringValue
                case "hexValue":
                    hex = val.stringValue
                case "RGB":
                    r = val["R"].doubleValue
                    g = val["G"].doubleValue
                    b = val["B"].doubleValue
                case "HSL":
                    h1 = val["H"].intValue
                    s1 = val["S"].doubleValue
                    l = val["L"].doubleValue
                case "HSV":
                    h2 = val["H"].intValue
                    s2 = val["S"].doubleValue
                    v = val["V"].doubleValue
                default:
                    println("Error!")
                }
            }
            
            self.myColors.addColor(col,hex:hex,red:r,green:g,blue:b,hue1:h1,sat1:s1,hue2:h2,sat2:s2,value:v,lightness:l)
        }
        self.myColors.printColors()
        println(self.myColors.fetchColorName("#CE2029"))
        println(self.myColors.fetchRGB("#CE2029"))
    }
    

    
    
    
}


