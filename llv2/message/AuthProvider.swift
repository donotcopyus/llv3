////
////  AuthProvider.swift
////  llv2
////
////  Created by 林蔼欣 on 2018-07-21.
////  Copyright © 2018 Luna Cao. All rights reserved.
////
//
//import Foundation
//import FirebaseAuth
//
//typealias LoginHandler = (_ msg: String?) -> Void;
//
//struct LoginErrorCode {
//    static let INVALID_EMAIL = "INVALID EMAIL";
//    static let WRONG_PASSWORD = "WRONG PASSWORD";
//    static let PROBLEM_CONNECTING = "PROBLEM CONNECTING";
//    static let USER_NOT_FOUND = "USER NOT FOUND";
//    static let EMAIL_ALREADY_USED = "EMAIL ALREADY USED";
//    static let WEAK_PASSWORD = "WEAK PASSWORD";
//
//}
//
//class OAuthProvider {
//    private static let _instance = OAuthProvider();
//
//    static var Instance: OAuthProvider {
//        return _instance;
//    }
//
//    var userName = "";
//
//    func login(withEmail: String, password: String, loginHandler: LoginHandler?) {
//
//        Auth.auth()?.singIn(withEmail: withEmail, password: password, completion: { (user, error) in
//
//            if error != nil {
//                self.handleErrors(err: error as! NSError, LoginHandler: LoginHandler);
//            } else {
//                loginHandler?(nil);
//            }
//        });
//    }
//
//
//    func signUp(withEmail: String, password: String, loginHandler: LoginHandler?) {
//        Auth.auth().singIn(withEmail: withEmail, password: password, completion: { (user, error) in
//
//            if error != nil {
//                self.handleErrors(err: error as! NSError, LoginHandler: LoginHandler);
//            } else {
//
//                if user?.uid != nil {
//                    DBProvider.Instance.saveUser(withID: user!.uid, email: withEmail, password: password);
//
//                    self.login(withEmail: withEmail, password: password, loginHandler: password);
//                }
//            }
//        });
//    }
//
//    func isLoggedIn() -> Bool {
//        if Auth.auth().currenUser != nil {
//            return true;
//        }
//
//        return false;
//    }
//
//    func logOut() -> Bool {
//        if Auth.auth().currenUser != nil {
//            do {
//                try Auth.auth().signOut();
//                return true;
//            } catch {
//                return false;
//            }
//        }
//
//        return true;
//    }
//
//
//    func usedID() -> String {
//        return Auth.auth().currentUser!.uid;
//    }
//
//
//    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {
//
//        if let errCode = AuthErrorCode(rawValue: err.code) {
//
//            switch errCode {
//
//            case .errorCodeWrongPassword:
//                loginHandler?(LoginErrorCode.WRONG_PASSWORD);
//                break;
//
//            case .errorCodeInvalidEmail:
//                loginHandler?(LoginErrorCode.INVALID_EMAIL);
//                break;
//
//            case .errorCodeUserNotFound:
//                loginHandler?(LoginErrorCode.USER_NOT_FOUND);
//                break;
//
//            case .errorCodeEmailAlreadUsed:
//                loginHandler?(LoginErrorCode.EMAIL_ALREADY_USED);
//                break;
//
//            case .errorCodeWeakPassword:
//                loginHandler?(LoginErrorCode.WEAK_PASSWORD);
//                break;
//
//            default:
//                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
//                break;
//
//            }
//        }
//    }
//
//
//
//
//
//
//}
