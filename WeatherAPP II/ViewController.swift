//
//  ViewController.swift
//  WeatherAPP II
//
//  Created by JokerChuang on 2014/8/16.
//  Copyright (c) 2014年 JokerChuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLConnectionDataDelegate{
    
    @IBOutlet var city: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var temperature: UILabel?
    @IBOutlet var weathericon: UIImageView!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var speed: UILabel!
    
    //使用 NSMutableData 儲存下載資料
    var data : NSMutableData = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // background image
        let background = UIImage(named: "Rainy-Wallpaper.jpg")
        self.view.backgroundColor = UIColor(patternImage: background)
        
        self.city.text = "Taipei"
        self.icon.image = UIImage(named: "rainy")
        self.weathericon.image = UIImage(named: "04d.png")
        
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        self.view.addGestureRecognizer(singleFingerTap)
    }
    
    func handleSingleTap(recogniser: UITapGestureRecognizer){
        
        startConnection()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

}

    
    func startConnection(){
        var restAPI: String = "http://api.openweathermap.org/data/2.5/weather?q=Taipei"
        var url: NSURL = NSURL(string: restAPI)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self,startImmediately: true)
        
        println("start download")
    }
    
    //下載中
    func connection(connection: NSURLConnection!, didReceiveData dataReceived: NSData!){
        println("downloading")
        
        self.data.setData(dataReceived)
        
        
    }
    //下載完成
    func connectionDidFinishLoading(connection: NSURLConnection!){
        println("download finished")
        
        var json = NSString(data: data, encoding: NSUTF8StringEncoding)
        println(json)
        
        
        // 解析 JSON
        
        // 使用 NSDictionary: NSDitionary 是一種 Associative Array 的資料結構
        var error: NSError?
        let jsonDictionay = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary                       // & 符號 - 傳遞參考
        
        // 讀取各項天氣概況
        let temp: AnyObject? = jsonDictionay["main"]?["temp"]
        let humidity: AnyObject? = jsonDictionay["main"]?["humidity"]
        let speed: AnyObject? = jsonDictionay["wind"]?["speed"]
        
        
        // 讀取即時天氣圖示
        if let weather = jsonDictionay["weather"]? as? NSArray {
            // safe code 寫作概念
            // 使用 as? 轉型時要把以下這行放進 if statement 裡處理
            let weatherDictionary = (weather[0] as NSDictionary)
            // 天氣狀態 (多雲 , 晴朗等等)
            let weatherID = weatherDictionary["id"] as Int
           // println("weather ID: \(weatherID)")
  
            switch weatherID {
            case 500, 501, 502, 503, 504:
                self.icon.image = UIImage(named: "RAIN.png")
                self.weathericon.image = UIImage(named: "rain_s.png")
                let background = UIImage(named: "rain_bg320px.png")
                self.view.backgroundColor = UIColor(patternImage: background)
                
            case 800, 801, 802 , 803:
                self.icon.image = UIImage(named: "sun.png")
                let background = UIImage(named: "sun_bg320px.png")
                self.weathericon.image = UIImage(named: "sun_s.png")
                self.view.backgroundColor = UIColor(patternImage: background)
                
            case 804:
                self.icon.image = UIImage(named: "CloudyDay.png")
                self.weathericon.image = UIImage(named: "cloudDay_s-2.png")
                let background = UIImage(named: "CloudyDay_bg320px.png")
                self.view.backgroundColor = UIColor(patternImage: background)
                
            default:
                println("unknow weather icon")
            }

            }
        
        // 資料處理
        let weatherTempCelsius = Int(round((temp!.floatValue - 273.15)))
        let weatherTempFahrenheit = Int(round(((temp!.floatValue - 273.15) * 1.8) + 32))
        let weatherHumidity = round(humidity!.floatValue)
        let weatherSpeed = round(speed!.floatValue)

        // 輸出到 UI
        self.temperature!.text = "\(weatherTempCelsius)℃"
        self.humidity.text = "\(weatherHumidity)%"
        self.speed.text = "\(weatherSpeed) m/s"
        
    }
}
