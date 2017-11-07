//
//  OMHClient.swift
//  Pods
//
//  Created by James Kizer on 1/6/17.
//
//

import Alamofire

open class OMHClient: NSObject {
    
    public struct SignInResponse {
        public let accessToken: String
        public let refreshToken: String
    }
    
    let baseURL: String
    let clientID: String
    let clientSecret: String
    let dispatchQueue: DispatchQueue?
    
    
    var basicAuthString: String {
        let authString = "\(self.clientID):\(self.clientSecret)" as NSString
        let authData: Data = authString.data(using: String.Encoding.utf8.rawValue)!
        let base64String: String = authData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        return base64String
    }
    
    public init(baseURL: String, clientID: String, clientSecret: String, dispatchQueue: DispatchQueue? = nil) {
        self.baseURL = baseURL
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.dispatchQueue = dispatchQueue
        super.init()
    }
    
    open func OAuthURL() -> URL? {
        return URL(string: "\(self.baseURL)/oauth/authorize?client_id=\(self.clientID)&response_type=code")
    }
    
    open func studyEnrollmentURL(studyIdentifier: String) -> URL? {
        return URL(string: "\(self.baseURL)/studies/\(studyIdentifier)/enroll")
    }
    
    open func processAuthResponse(isRefresh: Bool, completion: @escaping ((SignInResponse?, Error?) -> ())) -> ((DataResponse<Any>) -> ()) {
        
        return { jsonResponse in
            
            //check for lower level errors
            if let error = jsonResponse.result.error as? NSError {
                if error.code == NSURLErrorNotConnectedToInternet {
                    completion(nil, OMHClientError.unreachableError(underlyingError: error))
                    return
                }
                else {
                    completion(nil, OMHClientError.otherError(underlyingError: error))
                    return
                }
            }
            
            //check for our errors
            //credentialsFailure
            guard let response = jsonResponse.response else {
                completion(nil, OMHClientError.malformedResponse(responseBody: jsonResponse))
                return
            }
            
            if let response = jsonResponse.response,
                response.statusCode == 502 {
                debugPrint(jsonResponse)
                completion(nil, OMHClientError.badGatewayError)
                return
            }
            
            if response.statusCode != 200 {
                
                guard jsonResponse.result.isSuccess,
                    let json = jsonResponse.result.value as? [String: Any],
                    let error = json["error"] as? String,
                    let errorDescription = json["error_description"] as? String else {
                        completion(nil, OMHClientError.malformedResponse(responseBody: jsonResponse.result.value))
                        return
                }
                
                if error == "invalid_grant" {
                    if isRefresh {
                        completion(nil, OMHClientError.invalidRefreshToken)
                    }
                    else {
                        completion(nil, OMHClientError.credentialsFailure(descrition: errorDescription))
                    }
                    return
                }
                else {
                    completion(nil, OMHClientError.serverError(error: error, errorDescription: errorDescription))
                    return
                }
                
            }
            
            //malformed body
            guard jsonResponse.result.isSuccess,
                let json = jsonResponse.result.value as? [String: Any],
                let accessToken = json["access_token"] as? String,
                let refreshToken = json["refresh_token"] as? String else {
                    completion(nil, OMHClientError.malformedResponse(responseBody: jsonResponse.result.value))
                    return
            }
            
            let signInResponse = SignInResponse(accessToken: accessToken, refreshToken: refreshToken)
            
            completion(signInResponse, nil)
            
        }
        
    }
    
    open func signIn(username: String, password: String, completion: @escaping ((SignInResponse?, Error?) -> ())) {
        
        let urlString = "\(self.baseURL)/oauth/token"
        let parameters = [
            "grant_type": "password",
            "username": username,
            "password": password
        ]
        
        let headers = ["Authorization": "Basic \(self.basicAuthString)"]
        
        let request = Alamofire.request(
            urlString,
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers)
        
        request.responseJSON(queue: self.dispatchQueue, completionHandler: self.processAuthResponse(isRefresh: false, completion: completion))
        
    }
    
    open func signIn(code: String, completion: @escaping ((SignInResponse?, Error?) -> ())) {
        
        let urlString = "\(self.baseURL)/oauth/token"
        let parameters = [
            "grant_type": "authorization_code",
            "code": code
        ]
        
        let headers = ["Authorization": "Basic \(self.basicAuthString)"]
        
        let request = Alamofire.request(
            urlString,
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers)
        
        request.responseJSON(queue: self.dispatchQueue, completionHandler: self.processAuthResponse(isRefresh: false, completion: completion))
        
    }
    
    open func refreshAccessToken(refreshToken: String, completion: @escaping ((SignInResponse?, Error?) -> ()))  {
        let urlString = "\(self.baseURL)/oauth/token"
        let parameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken]
        
        let headers = ["Authorization": "Basic \(self.basicAuthString)"]
        
        let request = Alamofire.request(
            urlString,
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers)
        
        request.responseJSON(queue: self.dispatchQueue, completionHandler: self.processAuthResponse(isRefresh: true, completion: completion))

    }
    
    open func postSample(sample: OMHDataPoint, token: String, completion: @escaping ((Bool, Error?) -> ())) {
        return self.postSample(sampleDict: sample.toDict(), token: token, completion: completion)
    }
    
    open func validateSample(sample: OMHDataPoint) -> Bool {
        
        let sampleDict = sample.toDict()
        return JSONSerialization.isValidJSONObject(sampleDict)
        
    }
    
    open func postSample(
        sampleDict: OMHDataPointDictionary,
        mediaAttachments: [OMHMediaAttachment]? = nil,
        token: String,
        completion: @escaping ((Bool, Error?) -> ())) {
        
        if let attachments = mediaAttachments {
            self.postMediaSample(sampleDict: sampleDict, mediaFiles: attachments, token: token, completion: completion)
        }
        else {
            self.postJSONSample(sampleDict: sampleDict, token: token, completion: completion)
        }
        
    }
    
    private func processJSONResponse(completion: @escaping ((Bool, Error?) -> ())) -> (DataResponse<Any>) -> () {
        
        return { jsonResponse in
            //check for actually success
            //NOTE: quirk of ohmage, no body is sent in case of success
            if let error = jsonResponse.result.error as? AFError,
                let response = jsonResponse.response,
                error.isResponseSerializationError && response.statusCode == 201 {
                
                debugPrint(jsonResponse)
                completion(true, nil)
                return
            }
            
            //all errors from here down!
            if let response = jsonResponse.response,
                response.statusCode == 409 {
                debugPrint(jsonResponse)
                completion(false, OMHClientError.dataPointConflict)
                return
            }
            
            if let response = jsonResponse.response,
                response.statusCode == 502 {
                debugPrint(jsonResponse)
                completion(false, OMHClientError.badGatewayError)
                return
            }
            
            
            //check for lower level errors
            if let error = jsonResponse.result.error {
                debugPrint(jsonResponse)
                completion(false, error)
                return
            }
            
            guard let _ = jsonResponse.response else {
                completion(false, OMHClientError.malformedResponse(responseBody: jsonResponse))
                return
            }
            
            guard jsonResponse.result.isSuccess,
                let json = jsonResponse.result.value as? [String: Any],
                let error = json["error"] as? String,
                let errorDescription = json["error_description"] as? String else {
                    completion(false, OMHClientError.malformedResponse(responseBody: jsonResponse.result.value))
                    return
            }
            
            if error == "invalid_token" {
                completion(false, OMHClientError.invalidAccessToken)
                return
            }
            else {
                completion(false, OMHClientError.serverError(error: error, errorDescription: errorDescription))
                return
            }
        }
        
    }
    
    private func postJSONSample(sampleDict: OMHDataPointDictionary, token: String, completion: @escaping ((Bool, Error?) -> ())) {
        let urlString = "\(self.baseURL)/dataPoints"
        let headers = ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        let params = sampleDict
        
        guard JSONSerialization.isValidJSONObject(sampleDict) else {
            completion(false, OMHClientError.invalidDatapoint)
            return
        }
        
        let request = Alamofire.request(
            urlString,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers)
        
        let reponseProcessor: (DataResponse<Any>) -> () = self.processJSONResponse(completion: completion)
        
        request.responseJSON(queue: self.dispatchQueue, completionHandler: reponseProcessor)

    }
    
    private func postMediaSample(sampleDict: OMHDataPointDictionary, mediaFiles: [OMHMediaAttachment], token: String, completion: @escaping ((Bool, Error?) -> ())) {
        
        //create an upload request
        
        let urlString = "\(self.baseURL)/dataPoints"
        let headers = ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        var sampleData: Data!
        
        guard JSONSerialization.isValidJSONObject(sampleDict) else {
            completion(false, OMHClientError.invalidDatapoint)
            return
        }
        
        do {
            sampleData = try JSONSerialization.data(withJSONObject: sampleDict, options: JSONSerialization.WritingOptions(rawValue: 0))
        } catch let error as NSError {
            completion(false, error)
        }
        
        let request = Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            debugPrint(sampleData)
            
            multipartFormData.append(sampleData, withName: "data", mimeType: "application/json")
            

            
            mediaFiles.forEach({ (mediaAttachment) in
                debugPrint(mediaAttachment)
                multipartFormData.append(mediaAttachment.fileURL, withName: "media", fileName: mediaAttachment.fileName, mimeType: mediaAttachment.mimeType)
            })
            
        }, to: urlString, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                
                debugPrint(upload)
                debugPrint(upload.request)
                
                let reponseProcessor: (DataResponse<Any>) -> () = self.processJSONResponse(completion: completion)
                
                upload.responseJSON(queue: self.dispatchQueue, completionHandler: reponseProcessor)

            case .failure(let encodingError):
                completion(false, encodingError)
            }
        }
    
    }
    
}
