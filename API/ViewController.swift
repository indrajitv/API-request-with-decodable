//
//  ViewController.swift
//  API
//
//  Created by indrajit on 15/08/18.
//  Copyright © 2018 Indajit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        let request = APIRequest()
        request.doRequestForDecodable(decodablClass: StatusResp.self, method: .GET, queryString: " homescreen/banners", parameters: nil) { (decodable, error) in
            print(decodable?.success?.any)
        }
        
        let request1 = APIRequest()
        request1.doRequestForDecodable(decodablClass: StatusResp.self, method: .GET, queryString: " homescreen/banners", parameters: nil) { (decodable, error) in
            print(decodable?.success?.any)
        }
        
        let request3 = APIRequest()
        request3.doRequestForDecodable(decodablClass: StatusResp.self, method: .GET, queryString: " homescreen/banners", parameters: nil) { (decodable, error) in
            print(decodable?.success?.any)
        }
        
        let request4 = APIRequest()
        request4.doRequestForDecodable(decodablClass: StatusResp.self, method: .GET, queryString: " homescreen/banners", parameters: nil) { (decodable, error) in
            if let dblVal = decodable?.success?.any as? String{
                print(dblVal)
            }
        }
        
        
    }

  

    
    
    
    



}



class StatusResp:Decodable{
    var success:Id? // Here i am not sure which datatype my server guy will send
}




