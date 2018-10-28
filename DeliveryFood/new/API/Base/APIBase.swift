//
//  APIBase.swift
//  mvvm-sample
//
//  Created by Fernando Martinez on 5/3/16.
//  Copyright © 2016 fernandodev. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIBase {
    static var baseUrl = !Utils.shared.isTestApp() ? "http://manage.newbill.info" : "http://23.101.67.216:8080"
    static var defaultLoadingClosure: ((Bool)->())? = Config.AlertClosures.loading
    private var loadingClosure: ((Bool)->())?
    
    private weak var context: UIViewController?
    private var headers: [String:String] = [:]

    internal var apiName: String!
    
    init() {
        self.loadingClosure = APIBase.defaultLoadingClosure
    }
    
    convenience init(_ loadingClosure:((Bool)->())?) {
        self.init()
        self.loadingClosure = loadingClosure
    }
    
    convenience init(controller: UIViewController) {
        self.init()
        context = controller
    }

    //MARK: HTTP Methods
    func get(url: String, params: [String:AnyObject]?, success: @escaping ((_ result: JSON) -> Void), failure: @escaping (_ error: APIError) -> Void, completion: @escaping () -> Void  = {}) {
        request(method: .get, url: url, params: params, success: success, failure: failure)
    }

    func post(url: String, params: [String:Any]?, success: @escaping ((_ result: JSON) -> Void), failure: @escaping (_ error: APIError) -> Void, completion: @escaping () -> Void = {}) {
        request(method: .post, url: url, params: params, success: success, failure: failure)
    }
    
    func patch(url: String, params: [String:Any]?, success: @escaping ((_ result: JSON) -> Void), failure: @escaping (_ error: APIError) -> Void, completion: @escaping () -> Void = {}) {
        request(method: .patch, url: url, params: params, success: success, failure: failure)
    }
    
    func delete(url: String, success: @escaping (() -> Void), failure: @escaping (_ error: APIError) -> Void, completion: @escaping () -> Void = {}) {
        request(method: .delete, url: url, params: nil, success: { _ in success()}, failure: failure)
    }

    
    func request(method: HTTPMethod,  url: String, params: [String:Any]?, success: @escaping ((_ result: JSON) -> Void), failure: @escaping (_ error: APIError) -> Void, completion: @escaping () -> Void = {}) {
        loadingClosure?(true)
        
        debugPrint("\(method) request ", url, params?.description ?? "")
        if Utils.shared.isDebugMode() {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: self.headers).responseJSON { response in
                    self.handleResponse(response, success: success, failure: failure, completion: completion)
                }
            })
            return
        }
        
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            self.handleResponse(response, success: success, failure: failure, completion: completion)
        }
        
    }

    private func handleResponse(_ response: DataResponse<Any>, success: ((_ result: JSON) -> Void), failure: (_ error: APIError) -> Void, completion: () -> Void) {
        self.loadingClosure?(false)
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("raw request data: \(utf8Text)")
        }
        
        switch response.result {
        case .success:
            if let body = response.response {
                if let json = response.result.value, body.statusCode >= 200 && body.statusCode < 300   {
                    success(JSON(json))
                } else  {
                    handleErrors(
                        error: APIError(code: body.statusCode, requestBody: response.result.value as AnyObject, apiName: apiName),
                        failureCallback: failure
                    )
                }
            } else {
                handleErrors(
                    error: APIError(apiName: apiName),
                    failureCallback: failure
                )
            }
            break
        case .failure:
            let code = response.response?.statusCode ?? Int.max
            
            handleErrors(
                error: APIError(code: code, apiName:apiName),
                failureCallback: failure
            )
            break
        }
        completion()
    }

    private func handleErrors(error: APIError, failureCallback failure: (_ error: APIError) -> Void) {
        debugPrint("error: ", error.description)
        if error.code != APIError.NOT_FOUND {
            Config.AlertClosures.showError(Config.Texts.generalError)
        }
        failure(error)
    }
    
    //MARK: adding id
    internal var phoneIDParams: Parameters {
        get {
            return ["id": Utils.shared.phoneId as Any]
        }
    }
    
    //MARK: helpers
    func mergeParams(_ lhs: [String:Any], _ rhs: [String:Any]? ) -> [String:Any] {
        var result = lhs
        if !(rhs != nil) {
            return result
        }
        let lks = lhs.keys
        let rks = rhs!.keys
        for rk in rks {
            if !lks.contains(rk) {
                result[rk] = rhs![rk]
            } else {
                let rv = rhs![rk]
                let lv = lhs[rk]
                
                switch (lv, rv) {
                case let (ld, rd) as ([String:Any], [String:Any]):
                    result[rk] = mergeParams(ld, rd)
                default:
                    result[rk] = rv
                }
            }
        }
        
        return result
    }
}

extension Dictionary {
    mutating func extend(with:Dictionary) -> Dictionary{
        for (key,value) in with {
            self.updateValue(value, forKey:key)
        }
        return self
    }
}
