//
//  RSAFApplicationDelegate.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit
import ResearchKit
import ReSwift
import ResearchSuiteResultsProcessor
import ResearchSuiteTaskBuilder
import Gloss

open class RSAFApplicationDelegate: UIResponder, UIApplicationDelegate, ORKPasscodeDelegate, RSAFRootViewControllerProtocolDelegate {
    
    open var window: UIWindow?
    
//    var initializeStateClosure: (() -> Void)?
//    var resetStateClosure: (() -> Void)?
    
    open var reduxManager: RSAFReduxManager?
    
    open var reduxStore: Store<RSAFCombinedState>? {
        return reduxManager?.store
    }
    
    //the following are subscribers
    var persistenceManager: RSAFCombinedPersistentStoreSubscriber?
    open var extensibleStateManager: RSAFExtensibleStateManager?
    
//    open var taskBuilderManager: RSAFTaskBuilderManager?
//    open var resultsProcessorManager: RSAFResultsProcessorManager?
//    open var resultsProcessor: RSRPResultsProcessor?
    
    open func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        if UserDefaults.standard.object(forKey: "FirstRun") == nil {
            UserDefaults.standard.set("1stRun", forKey: "FirstRun")
            UserDefaults.standard.synchronize()
            do {
                try ORKKeychainWrapper.resetKeychain()
            } catch let error {
                print("Got error \(error) when resetting keychain")
            }
        }
        
        self.initializeStoreAndSubscribe()
        
        if let store = self.reduxStore,
            let state = store.state as? RSAFCombinedState {
            
            self.showViewController(state: state)
        }

        return true
    }
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        lockScreen()
        return true
    }
    
//    open func setLoggedInAndShowViewController(loggedIn: Bool, completion: @escaping () -> Void) {
//        let store = self.reduxStoreManager?.store
//        store?.dispatch(CTFActionCreators.setLoggedIn(loggedIn: loggedIn), callback: { (state) in
//            self.showViewController(state: state)
//            completion()
//        })
//    }
    
    open func isSignedIn(state: RSAFCombinedState) -> Bool {
        guard let coreState = state.coreState as? RSAFCoreState else {
            return false
        }
        return RSAFCoreSelectors.isLoggedIn(coreState)
    }
    
    open func showViewController(state: RSAFCombinedState) {
        
        //check for case where a failure occurs during login
        if isSignedIn(state: state) && !ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            self.signOut()
        }
        
        if !isSignedIn(state: state) && ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            self.signOut()
        }
        
        if isSignedIn(state: state) && ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            
            if let vc = self.instantiateMainViewController(),
                var rvc = vc as? RSAFRootViewControllerProtocol {
                rvc.RSAFDelegate = self
                self.transition(toRootViewController: vc, animated: true)
                return
            }
            
        }
        else {
            if let vc = self.instantiateOnboardingViewController(),
                var rvc = vc as? RSAFRootViewControllerProtocol {
                rvc.RSAFDelegate = self
                self.transition(toRootViewController: vc, animated: true)
                return
            }
        }
        
        return
    }
    
    open func instantiateMainViewController() -> UIViewController? {
        return nil
    }
    
    open func instantiateOnboardingViewController() -> UIViewController? {
        return nil
    }
    
    
    /**
     Convenience method for presenting a modal view controller.
     */
    open func presentViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let rootVC = self.window?.rootViewController else { return }
        var topViewController: UIViewController = rootVC
        while (topViewController.presentedViewController != nil) {
            topViewController = topViewController.presentedViewController!
        }
        topViewController.present(viewController, animated: animated, completion: completion)
    }
    
    /**
     Convenience method for transitioning to the given view controller as the main window
     rootViewController.
     */
    open func transition(toRootViewController: UIViewController, animated: Bool, completion: ((Bool) -> Swift.Void)? = nil) {
        guard let window = self.window else { return }
        if (animated) {
            let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
            toRootViewController.view.addSubview(snapshot);
            
            self.window?.rootViewController = toRootViewController;
            
            UIView.animate(withDuration: 0.3, animations: {() in
                snapshot.layer.opacity = 0;
            }, completion: {
                (value: Bool) in
                snapshot.removeFromSuperview()
                completion?(value)
            })
        }
        else {
            window.rootViewController = toRootViewController
            completion?(true)
        }
    }
    
    // ------------------------------------------------
    // MARK: Passcode Display Handling
    // ------------------------------------------------
    
    open weak var passcodeViewController: UIViewController?
    
    /**
     Should the passcode be displayed. By default, if there isn't a catasrophic error,
     the user is registered and there is a passcode in the keychain, then show it.
     */
    open func shouldShowPasscode() -> Bool {
        return (self.passcodeViewController == nil) &&
            ORKPasscodeViewController.isPasscodeStoredInKeychain()
    }
    
    open func instantiateViewControllerForPasscode() -> UIViewController? {
        return ORKPasscodeViewController.passcodeAuthenticationViewController(withText: nil, delegate: self)
    }
    
    open func lockScreen() {
        
        guard self.shouldShowPasscode(), let vc = instantiateViewControllerForPasscode() else {
            return
        }
        
        window?.makeKeyAndVisible()
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        
        passcodeViewController = vc
        presentViewController(vc, animated: false, completion: nil)
    }
    
    open func dismissPasscodeViewController(_ animated: Bool) {
        self.passcodeViewController?.presentingViewController?.dismiss(animated: animated, completion: nil)
    }
    
    open func resetPasscode() {
        
        // Dismiss the view controller unanimated
        dismissPasscodeViewController(false)
        
        self.signOut()
    }
    
    // MARK: ORKPasscodeDelegate
    
    open func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {
        dismissPasscodeViewController(true)
    }
    
    open func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
        // Do nothing in default implementation
    }
    
    open func passcodeViewControllerForgotPasscodeTapped(_ viewController: UIViewController) {
        
        let title = "Reset Passcode"
        let message = "In order to reset your passcode, you'll need to log out of the app completely and log back in using your email and password."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.resetPasscode()
        })
        alert.addAction(logoutAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    open func subscribeToStore(store: Store<RSAFCombinedState>) {
        //these should always exist
        store.subscribe(self.persistenceManager!)
        store.subscribe(self.extensibleStateManager!)
    }
    
    open func unsubscribeFromStore(store: Store<RSAFCombinedState>) {
        
        store.unsubscribe(self.persistenceManager!)
        store.unsubscribe(self.extensibleStateManager!)
        
    }
    
    
//    open func resultsProcessorFrontEndTransformers() -> [RSRPFrontEndTransformer.Type] {
//        return []
//    }
//    
//    open func resultsProcessorBackEnds() -> [RSRPBackEnd] {
//        return [
//            RSAFFakeBackEnd()
//        ]
//    }
//    
//    open func createResultsProcessor() -> RSRPResultsProcessor {
//        return RSRPResultsProcessor(
//            frontEndTransformers: self.resultsProcessorFrontEndTransformers(),
//            backEnds: self.resultsProcessorBackEnds()
//        )
//    }
    
    open func createExtensibleStateManager(store: Store<RSAFCombinedState>) -> RSAFExtensibleStateManager {
        return RSAFExtensibleStateManager(store: store)
    }
    
//    open func createTaskBuilderManager(stateHelper: RSTBStateHelper) -> RSAFTaskBuilderManager {
//        return RSAFTaskBuilderManager(stateHelper: stateHelper)
//    }
    
    open func loadCombinedReducer() -> RSAFCombinedReducer {
        return RSAFCombinedReducer(
            coreReducer: RSAFCoreReducer(),
            middlewareReducer: RSAFBaseReducer(),
            appReducer: RSAFBaseReducer()
        )
    }
    
    open func loadPersistenceManager(stateManager: RSAFStateManager.Type) -> RSAFCombinedPersistentStoreSubscriber {
        return RSAFCombinedPersistentStoreSubscriber(
            coreSubscriber: RSAFCorePersistentStoreSubscriber(stateManager: stateManager),
            middlewareSubscriber: RSAFBasePersistentStoreSubscriber(stateManager: stateManager),
            appSubscriber: RSAFBasePersistentStoreSubscriber(stateManager: stateManager)
        )
    }
    
    open func initialDispatch(store: Store<RSAFCombinedState>) {
        
        store.dispatch(RSAFActionCreators.setTitleInfo(titleLabelText: self.titleLabelText, titleImage: self.titleImage))
        
    }
    
    open func initializeStoreAndSubscribe() {
        
        let store = initializeStore()
        self.subscribeToStore(store: store)
        
        self.initialDispatch(store: store)
    }
    
    open func initializeStore() -> Store<RSAFCombinedState> {
        
        let keychainStateManager:RSAFStateManager.Type = RSAFKeychainStateManager.self
        let persistenceManager = loadPersistenceManager(stateManager: keychainStateManager)
        let persistedState: RSAFCombinedState = persistenceManager.loadState()
        let combinedReducer: RSAFCombinedReducer = loadCombinedReducer()
        
        let storeManager: RSAFReduxManager = RSAFReduxManager(initialState: persistedState, reducer: combinedReducer)
        
        let extensibleStateHelper = self.createExtensibleStateManager(store: storeManager.store)
//        let taskBuilderManager  = self.createTaskBuilderManager(stateHelper: extensibleStateHelper)
//        let resultsProcessor = self.createResultsProcessor()
        
        self.reduxManager = storeManager
        self.extensibleStateManager = extensibleStateHelper
        self.persistenceManager = persistenceManager
//        self.taskBuilderManager = taskBuilderManager
//        self.resultsProcessor = resultsProcessor

        return storeManager.store
        
    }
    
    open func unsubscribeAndResetStore() {
        if let store = self.reduxManager?.store {
            self.unsubscribeFromStore(store: store )
        }
        
        self.resetStore()
    }
    open func resetStore() {
        
        self.reduxManager = nil
        self.persistenceManager = nil
//        self.taskBuilderManager = nil
//        self.resultsProcessor = nil
        
        RSAFKeychainStateManager.clearKeychain()
        
        self.initializeStoreAndSubscribe()
        
    }
    
    open func signOut() {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        self.transition(toRootViewController: vc, animated: true, completion: { finished in
            
            DispatchQueue.main.async {
                
                self.unsubscribeAndResetStore()
                
                if let store = self.reduxStore,
                    let state = store.state as? RSAFCombinedState {
                    self.showViewController(state: state)
                }
                
            }
            
            
        })
    }
    
    open func loadSchedule(filename: String) -> RSAFSchedule? {
        guard let json = RSAFTaskBuilderManager.getJson(forFilename: filename) as? JSON else {
            return nil
        }
        
        return RSAFSchedule(json: json)
    }
    
    open class var stepGeneratorServices: [RSTBStepGenerator] {
        return [
            RSTBInstructionStepGenerator(),
            RSTBTextFieldStepGenerator(),
            RSTBIntegerStepGenerator(),
            RSTBDecimalStepGenerator(),
            RSTBTimePickerStepGenerator(),
            RSTBFormStepGenerator(),
            RSTBDatePickerStepGenerator(),
            RSTBSingleChoiceStepGenerator(),
            RSTBMultipleChoiceStepGenerator(),
            RSTBBooleanStepGenerator(),
            RSTBPasscodeStepGenerator(),
            RSTBScaleStepGenerator()
        ]
    }
    
    open class var answerFormatGeneratorServices:  [RSTBAnswerFormatGenerator] {
        return [
            RSTBTextFieldStepGenerator(),
            RSTBIntegerStepGenerator(),
            RSTBDecimalStepGenerator(),
            RSTBTimePickerStepGenerator(),
            RSTBDatePickerStepGenerator(),
            RSTBScaleStepGenerator()
        ]
    }
    
    open class var elementGeneratorServices: [RSTBElementGenerator] {
        return [
            RSTBElementListGenerator(),
            RSTBElementFileGenerator(),
            RSTBElementSelectorGenerator()
        ]
    }
    
    open class var resultsProcessorFrontEndTransformers: [RSRPFrontEndTransformer.Type] {
        return []
    }
    
    open var titleLabelText: String? {
        return nil
    }
    
    open var titleImage: UIImage? {
        return nil
    }
    
    open func activityRunDidComplete(activityRun: RSAFActivityRun) {
        
    }
}
