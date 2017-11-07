//
//  OhmageOMHSDK.swift
//  OhmageOMHSDK
//
//  Created by James Kizer on 1/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//


import Foundation
import OMHClient
import SecureQueue
import Alamofire

let kAccessToken = "AccessToken"
let kRefreshToken = "RefreshToken"

public protocol OhmageOMHSDKCredentialStore {
    func set(value: NSSecureCoding?, key: String)
    func get(key: String) -> NSSecureCoding?
}

public protocol OhmageOMHLogger {
    func log(_ debugString: String)
}

public class OhmageOMHManager: NSObject {
    
    public typealias MediaAttachmentUploadSuccess = (OMHMediaAttachment) -> ()
    public typealias DatapointUploadSuccess = (OMHDataPointDictionary) -> ()
    
    var client: OMHClient!
    var secureQueue: SecureQueue!
    
    var credentialsQueue: DispatchQueue!
    var credentialStore: OhmageOMHSDKCredentialStore!
    var credentialStoreQueue: DispatchQueue!
    var accessToken: String?
    var refreshToken: String?
    
    var uploadQueue: DispatchQueue!
    var isUploading: Bool = false
    
    public var onMediaAttachmentUploaded: MediaAttachmentUploadSuccess?
    public var onDatapointUploaded: DatapointUploadSuccess?
    
    public var logger: OhmageOMHLogger?
    
    let reachabilityManager: NetworkReachabilityManager
    
    var protectedDataAvaialbleObserver: NSObjectProtocol!
    
    static private let staticQueue = DispatchQueue(label: "staticQueue")
    
    static public var shared: OhmageOMHManager! {
        return staticQueue.sync {
            _sharedManager
        }
    }
    
    static private var _sharedManager: OhmageOMHManager?
    private var redirectCompletion: ((Error?) -> ())?
    
    
    //returns true if configured
//    static public func config(baseURL: String, clientID: String, clientSecret: String, queueStorageDirectory: String, store: OhmageOMHSDKCredentialStore, logger: OhmageOMHLogger? = nil) -> Bool {
//        return staticQueue.sync {
//            guard _sharedManager == nil,
//                let newManager = OhmageOMHManager(baseURL: baseURL, clientID: clientID, clientSecret: clientSecret, queueStorageDirectory: queueStorageDirectory, store: store) else {
//                    return false
//            }
//            
//            _sharedManager = newManager
//            _sharedManager?.logger = logger
//            return true
//        }
//    }
    
    public init?(
        baseURL: String,
        clientID: String,
        clientSecret: String,
        queueStorageDirectory: String,
        store: OhmageOMHSDKCredentialStore,
        logger: OhmageOMHLogger? = nil
        ) {
        
        self.uploadQueue = DispatchQueue(label: "UploadQueue")
        
        self.client = OMHClient(baseURL: baseURL, clientID: clientID, clientSecret: clientSecret, dispatchQueue: self.uploadQueue)
        self.secureQueue = SecureQueue(directoryName: queueStorageDirectory, allowedClasses: [NSDictionary.self, NSArray.self, OMHMediaAttachment.self])
        
        self.credentialsQueue = DispatchQueue(label: "CredentialsQueue")
        
        self.credentialStore = store
        self.credentialStoreQueue = DispatchQueue(label: "CredentialStoreQueue")
        
        if let accessToken = self.credentialStore.get(key: kAccessToken) as? String {
            self.accessToken = accessToken
        }
        
        if let refreshToken = self.credentialStore.get(key: kRefreshToken) as? String {
            self.refreshToken = refreshToken
        }
        
        guard let url = URL(string: baseURL),
            let host = url.host,
            let reachabilityManager = NetworkReachabilityManager(host: host) else {
            return nil
        }
        
        self.reachabilityManager = reachabilityManager
        
        self.logger = logger
        
        super.init()
        
        //set up listeners for the following events:
        // 1) we have access to the internet
        // 2) we have access to protected data
        
        let startUploading = self.startUploading
        
        reachabilityManager.listener = { [weak self] status in
            if reachabilityManager.isReachable {
                do {
                    try startUploading()
                } catch let error {
                    debugPrint(error)
                }
            }
        }
        
        if self.isSignedIn {
            reachabilityManager.startListening()
        }
  
        
        self.protectedDataAvaialbleObserver = NotificationCenter.default.addObserver(forName: .UIApplicationProtectedDataDidBecomeAvailable, object: nil, queue: nil) { [weak self](notification) in
            do {
                try startUploading()
            } catch let error as NSError {
                self?.logger?.log("error occurred when starting upload after device unlock: \(error.localizedDescription)")
                debugPrint(error)
            }
            
        }
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self.protectedDataAvaialbleObserver)
    }
    
    public func signIn(username: String, password: String, completion: @escaping ((Error?) -> ())) {
        
        if self.isSignedIn {
            completion(OhmageOMHError.alreadySignedIn)
            return
        }
        
        
        self.client.signIn(username: username, password: password) { (signInResponse, error) in
            
            if let err = error {
                
                completion(err)
                return
                
            }
            
            if let response = signInResponse {
                self.setCredentials(accessToken: response.accessToken, refreshToken: response.refreshToken)
            }
            
            self.reachabilityManager.startListening()
            completion(nil)
            
        }
        
    }
    
    public func beginRedirectSignIn(completion: @escaping ((Error?) -> ())) {
        
        if self.isSignedIn {
            completion(OhmageOMHError.alreadySignedIn)
            return
        }
        
        if let url = self.client.OAuthURL() {
            self.redirectCompletion = completion
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    public func enrollUserInStudy(studyIdentifier: String, completion: @escaping ((Error?) -> ())) {
        if !self.isSignedIn {
            completion(OhmageOMHError.notSignedIn)
            return
        }
        
        if let url = self.client.studyEnrollmentURL(studyIdentifier: studyIdentifier) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    completion(nil)
                })
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
                completion(nil)
            }
        }
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    public func handleURL(url: URL) -> Bool {

        if let code = self.getQueryStringParameter(url: url.absoluteString, param: "code") {
            self.client.signIn(code: code) { (signInResponse, error) in
                
                if let err = error {
                    
                    self.redirectCompletion?(err)
                    return
                    
                }
                
                if let response = signInResponse {
                    self.setCredentials(accessToken: response.accessToken, refreshToken: response.refreshToken)
                }
                
                self.reachabilityManager.startListening()
                self.redirectCompletion?(nil)
                
            }
        }
        
        return true
    }
    
    public func signOut(completion: @escaping ((Error?) -> ())) {
        do {
            
            self.reachabilityManager.stopListening()
            
            try self.secureQueue.clear()
            self.clearCredentials()
            
            completion(nil)
            
        } catch let error {
            completion(error)
        }
    }
    
    public var isSignedIn: Bool {
        return self.credentialsQueue.sync {
            return self.refreshToken != nil
        }
    }
    
    public var queueIsEmpty: Bool {
        return self.secureQueue.isEmpty
    }
    
    public var queueItemCount: Int {
        return self.secureQueue.count
    }
    
    private func clearCredentials() {
        self.credentialsQueue.sync {
            self.credentialStoreQueue.async {
                self.credentialStore.set(value: nil, key: kAccessToken)
                self.credentialStore.set(value: nil, key: kRefreshToken)
            }
            self.accessToken = nil
            self.refreshToken = nil
            return
        }
    }
    
    private func setCredentials(accessToken: String, refreshToken: String) {
        self.credentialsQueue.sync {
            self.credentialStoreQueue.async {
                self.credentialStore.set(value: accessToken as NSString, key: kAccessToken)
                self.credentialStore.set(value: refreshToken as NSString, key: kRefreshToken)
            }
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            return
        }
    }
    
    public func addDatapoint(datapoint: OMHDataPoint, completion: @escaping ((Error?) -> ())) {
        
        if !self.isSignedIn {
            completion(OhmageOMHError.notSignedIn)
            return
        }
        
        if !self.client.validateSample(sample: datapoint) {
            completion(OhmageOMHError.invalidSample)
            return
        }
        
        do {
            
            var elementDictionary: [String: Any] = [
                "datapoint": datapoint.toDict()
            ]
            
            if let mediaDatapoint = datapoint as? OMHMediaDataPoint {
                elementDictionary["mediaAttachments"] = mediaDatapoint.attachments as NSArray
            }
            
            try self.secureQueue.addElement(element: elementDictionary as NSDictionary)
        } catch let error {
            completion(error)
            return
        }
        
        self.upload()
        completion(nil)
        
    }
    
    public func startUploading() throws {
        
        if !self.isSignedIn {
            throw OhmageOMHError.notSignedIn
        }
        
        self.upload()
    }
    
    private func upload() {
        self.uploadQueue.async {
            
            guard let queue = self.secureQueue,
                !queue.isEmpty,
                !self.isUploading else {
                    return
            }
            
            
            do {
                
//                debugPrint(try self.secureQueue.getFirstElement())
                
                if let (elementId, value) = try self.secureQueue.getFirstElement(),
                    let dataPointDict = value as? [String: Any],
                    let datapoint = dataPointDict["datapoint"] as? [String: Any],
                    let token = self.accessToken {
                    
                    let mediaAttachments: [OMHMediaAttachment]? = dataPointDict["mediaAttachments"] as? [OMHMediaAttachment]
                    let mediaAttachmentUploadSuccess = self.onMediaAttachmentUploaded
                    let datapointUploadSuccess = self.onDatapointUploaded
                    
                    self.isUploading = true
                    
                    if let datapointHeader = datapoint["header"] as? [String: Any],
                        let datapointId = datapointHeader["id"] as? String {
                        self.logger?.log("posting datapoint with id: \(datapointId)")
                    }
                    
                    self.client.postSample(sampleDict: datapoint, mediaAttachments: mediaAttachments, token: token, completion: { (success, error) in
                        
                        
                        //note that the OHMClient callbacks are executing on UploadQueue,
                        //therefore, we can set this here
                        self.isUploading = false
                        
                        if let err = error {
                            debugPrint(err)
                            self.logger?.log("Got error while posting datapoint: \(error.debugDescription)")
                            //should we retry here?
                            // and if so, under what conditions
                            
                            //may need to refresh
                            switch error {
                            case .some(OMHClientError.invalidAccessToken):
                                
                                self.logger?.log("invalid access token: refreshing")
                                
                                if let refreshToken = self.refreshToken {
                                    self.client.refreshAccessToken(refreshToken: refreshToken, completion: { (signInResponse, error) in
                                        if error != nil {
                                            self.clearCredentials()
                                        }
                                        else if let response = signInResponse {
                                            self.setCredentials(accessToken: response.accessToken, refreshToken: response.refreshToken)
                                            self.upload()
                                        }
                                
                                    })
                                }
                                return
                            //we've already tried to upload this data point
                            //we can remove it from the queue
                            case .some(OMHClientError.dataPointConflict):
                                
                                self.logger?.log("datapoint conflict: removing")
                                
                                do {
                                    try self.secureQueue.removeElement(elementId: elementId)
                                    
                                } catch let error {
                                    //we tried to delete,
                                    debugPrint(error)
                                }
                                
                                self.upload()
                                return
                                
                            case .some(OMHClientError.badGatewayError):
                                self.logger?.log("bad gateway")
                                return
                                
                                
                            default:
                                
                                if let nsError = error as? NSError {
                                    switch (nsError.code) {
                                    case NSURLErrorNetworkConnectionLost:
                                        self.logger?.log("We have an internet connecction, but cannot connect to the server. Is it down?")
                                        
                                        return
                                        
                                    default:
                                        break
                                        
                                    }
                                    
                                }
                                
                                debugPrint(error)
                                //if we have no internet access, don't try to reload
                                self.logger?.log("other error: retry \(error)")
                                
                                if self.reachabilityManager.isReachable {
//                                    self.upload()
                                    return
                                }
                                
                                
                            }
                            
                        } else if success {
                            //remove from queue
                            self.logger?.log("success: removing data point")
                            do {
                                try self.secureQueue.removeElement(elementId: elementId)
                                
                            } catch let error {
                                //we tried to delete, 
                                debugPrint(error)
                            }
                            
                            DispatchQueue.main.async {
                                datapointUploadSuccess?(datapoint)
                                
                                mediaAttachments?.forEach({ (attachment) in
                                    mediaAttachmentUploadSuccess?(attachment)
                                })
                            }
                            
                            self.upload()
                            
                        }
                        
                    })
                }
                
                else {
                    self.logger?.log("either we couldnt load a valid datapoint or there is no token")
                }
                
            } catch let error {
                //assume file system encryption error when tryong to read
                self.logger?.log("secure queue threw when trying to get first element: \(error)")
                debugPrint(error)
                
                //try uploading datapoint from memory
                self.uploadFromMemory()
                
            }
        }
    }
    
    private func uploadFromMemory() {
        self.uploadQueue.async {
            guard let queue = self.secureQueue,
                !queue.isEmpty,
                !self.isUploading else {
                    return
            }
            
            if let (elementId, value) = self.secureQueue.getFirstInMemoryElement(),
                let dataPointDict = value as? [String: Any],
                let datapoint = dataPointDict["datapoint"] as? [String: Any],
                let token = self.accessToken {
                
                let mediaAttachments: [OMHMediaAttachment]? = dataPointDict["mediaAttachments"] as? [OMHMediaAttachment]
                let mediaAttachmentUploadSuccess = self.onMediaAttachmentUploaded
                let datapointUploadSuccess = self.onDatapointUploaded
                
                self.isUploading = true
                
                if let datapointHeader = datapoint["header"] as? [String: Any],
                    let datapointId = datapointHeader["id"] as? String {
                    self.logger?.log("posting datapoint with id: \(datapointId)")
                }
                
                self.client.postSample(sampleDict: datapoint, token: token, completion: { (success, error) in
                    
                    //note that the OHMClient callbacks are executing on UploadQueue,
                    //therefore, we can set this here
                    self.isUploading = false
                    
                    if let err = error {
                        debugPrint(err)
                        
                        self.logger?.log("Got error while posting datapoint: \(error.debugDescription)")
                        
                        //should we retry here?
                        // and if so, under what conditions
                        
                        //may need to refresh
                        switch error {
                        case .some(OMHClientError.invalidAccessToken):
                            
                            self.logger?.log("invalid access token: refreshing")
                            
                            if let refreshToken = self.refreshToken {
                                self.client.refreshAccessToken(refreshToken: refreshToken, completion: { (signInResponse, error) in
                                    if error != nil {
                                        self.clearCredentials()
                                        return
                                    }
                                    else if let response = signInResponse {
                                        self.setCredentials(accessToken: response.accessToken, refreshToken: response.refreshToken)
                                        
                                        self.uploadFromMemory()
                                    }
                                    
                                })
                            }
                            return
                        //we've already tried to upload this data point
                        //we can remove it from the queue
                        case .some(OMHClientError.dataPointConflict):
                            
                            self.logger?.log("datapoint conflict: removing")
                            
                            do {
                                try self.secureQueue.removeElement(elementId: elementId)
                                
                            } catch let error {
                                //we tried to delete,
                                debugPrint(error)
                            }
                            
                            self.uploadFromMemory()
                            return
                            
                        case .some(OMHClientError.badGatewayError):
                            self.logger?.log("bad gateway")
                            return
                            
                        default:
                            
                            if let nsError = error as? NSError {
                                switch (nsError.code) {
                                case NSURLErrorNetworkConnectionLost:
                                    self.logger?.log("We have an internet connecction, but cannot connect to the server. Is it down?")
                                    
                                    return
                                    
                                default:
                                    break
                                    
                                }
                                
                            }
                            
                            
                            //maybe the default should not be try again?
                            debugPrint(error)
                            self.logger?.log("other error: retry \(error)")
                            if self.reachabilityManager.isReachable {
//                                self.uploadFromMemory()
                                return
                            }
                            
                        }
                        
                    } else if success {
                        //remove from queue
                        self.logger?.log("success: removing data point")
                        do {
                            try self.secureQueue.removeElement(elementId: elementId)
                            
                        } catch let error {
                            //we tried to delete,
                            debugPrint(error)
                        }
                        
                        DispatchQueue.main.async {
                            datapointUploadSuccess?(datapoint)
                            
                            mediaAttachments?.forEach({ (attachment) in
                                mediaAttachmentUploadSuccess?(attachment)
                            })
                        }
                        
                        self.uploadFromMemory()
                        
                    }
                    
                })
            }
            else {
                self.logger?.log("either we couldnt load a valid datapoint or there is no token")
            }
        }
    }

}
