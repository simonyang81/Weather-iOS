//
//  HttpUtils.swift
//  Weather-iOS
//
//  Created by Simon Yang on 8/18/15.
//  Copyright (c) 2015 Simon Yang. All rights reserved.
//

import Foundation

let appid = "674bcdb14c84aee2"
let Private_Key = "b43bc0_SmartWeatherAPI_91a7748"

class HttpUtils: NSObject {

    class func getRequest(areaName:String) -> String {
        
        var dateFormat:NSDateFormatter = NSDateFormatter();
        dateFormat.dateFormat = "yyyyMMddHHmm"
        var time = dateFormat.stringFromDate(NSDate())
        
        let index = advance(appid.startIndex, 6)
        var sixApi = appid.substringToIndex(index)
        
        println("HttpUtils.getRequest(), areaName == \(areaName)")
        
        var areaid = DBUtils.getAreaid(areaName)

//        areaid = DBUtils.getAreaid(areaName)

        
        var urlhead = "http://open.weather.com.cn/data/?areaid=\(areaid)&type=forecast_f&date=\(time)&appid=\(sixApi)"
        var publicKey = "http://open.weather.com.cn/data/?areaid=\(areaid)&type=forecast_f&date=\(time)&appid=\(appid)"
        var key = SecurityUtil.hmacSha1(publicKey, Private_Key) as NSString
        var encodePropert = key.URLEncodedString()
        var urlString = "\(urlhead)&key=\(encodePropert)"
        println("HttpUtils.getRequest(), url == \(urlString)")
        
        return urlString
        
    }
    
}