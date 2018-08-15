//
//  File.swift
//  APIRequest
//
//  Created by Indajit on 26/04/18.
//  Copyright © 2018 Indajit. All rights reserved.
//

import UIKit

class APIRequest:NSObject{
   
    fileprivate static let baseUrl = ""
    
    func doRequestForJson(method:MethodName,queryString:String?,parameters:[String:Any]?,showLoading:Bool = true,returnError:Bool = false,completionHandler:@escaping (Any?,String?)->()){
        
        getDataFromServer(method: method, queryString: queryString, parameters: parameters, showLoading: showLoading, returnError: returnError) { (data, error) in
            if let errorFound = error{
                completionHandler(nil, errorFound)
            }else if let dataFound = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: dataFound, options: .mutableContainers)
                    completionHandler(json, nil)
                }catch let err{
                    print(err.localizedDescription)
                    if returnError{
                        completionHandler(nil,"Something went wrong")
                    }else{
                        self.someThingWrong()
                    }
                }
            }
        }
    }
    
    func doRequestForDecodable<T : Decodable>(decodablClass:T.Type,method:MethodName,queryString:String?,parameters:[String:Any]?,showLoading:Bool = true,returnError:Bool = false,completionHandler:@escaping (T?,String?)->()){
       
        getDataFromServer(method: method, queryString: queryString, parameters: parameters, showLoading: showLoading, returnError: returnError) { (data, error) in
            if let errorFound = error{
                completionHandler(nil, errorFound)
            }else if let dataFound = data{
                do{
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodable = try jsonDecoder.decode(decodablClass.self, from: dataFound)
                    
                    completionHandler(decodable, nil)
                }catch let err{
                    print(err.localizedDescription)
                    if returnError{
                        completionHandler(nil,"Something went wrong")
                    }else{
                        self.someThingWrong()
                    }
                }
            }
        }
        
    }
    
    func someThingWrong(msg:String = "Something went wrong"){
        print("Someting went wrong")
    }
    
    
   fileprivate func getDataFromServer(method:MethodName,queryString:String?,parameters:[String:Any]?,showLoading:Bool = true,returnError:Bool = false,completionHandler:@escaping (Data?,String?)->()){
        
        var baseURLString = APIRequest.baseUrl
        if var query = queryString{
            query = query.replacingOccurrences(of: " ", with: "")
            if let first = query.first,first == "/"{
                query = String(query.dropFirst())
            }
            baseURLString += query
        }
        if let url = URL(string: baseURLString){
            
            var request = URLRequest(url: url,timeoutInterval: 60)
            request.httpMethod = method.rawValue
            if let params = parameters{
                do{
                    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                }catch let err{
                    if returnError{
                        completionHandler(nil, err.localizedDescription)
                    }else{
                        self.someThingWrong()
                    }
                }
            }
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                
                DispatchQueue.main.async(execute: {
                    
                    if let errorFound = error{
                        
                        if returnError{
                            completionHandler(nil, errorFound.localizedDescription)
                        }else{
                            self.someThingWrong(msg: errorFound.localizedDescription)
                        }
                        
                    }else if let dataFound = data{
                        print("Response - ",String(data: dataFound, encoding: .utf8)!)
                        completionHandler(dataFound, nil)
                    }else if returnError{
                        completionHandler(nil,"No data found")
                    }else{
                        completionHandler(nil,"No data found")
                    }
                })
            }).resume()
        }else{
            
            print("Invalid URL")
            if returnError{
                completionHandler(nil,"No data found")
            }else{
                self.someThingWrong()
            }
        }
    }
    
    
    
    
}


enum MethodName:String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}


enum Id: Decodable {
    
    case int(Int), double(Double), string(String) // Add more cases if you want
    
    init(from decoder: Decoder) throws {
        
        //Check each case
        if let dbl = try? decoder.singleValueContainer().decode(Double.self),dbl.truncatingRemainder(dividingBy: 1) != 0  { // It is double not a int value
            self = .double(dbl)
            return
        }
        
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        throw IdError.missingValue
    }
    
    enum IdError:Error { // If no case matched
        case missingValue
    }
    
    var any:Any{
        get{
            switch self {
            case .double(let value):
                return value
            case .int(let value):
                return value
            case .string(let value):
                return value
            }
        }
    }
}



