//
//  LoginView.swift
//  AppointmentApp
//
//  Created by William Zhang on 5/28/24.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    func signInWithApple(){
        
    }
    
}

//struct LoginView: View {
//    @StateObject var viewModel = LoginViewModel()
//    let loginApple = SignInApple()
//    
//    var body: some View {
//        Button {
//            loginApple.startSignInWithAppleFlow {  result in
//                switch result {
//                case .success(let appleResult):
//                    print(appleResult)
//                case .failure(let error):
//                    print("error")
//                }
//            }
//        } label: {
//            Text("Sign in with Apple")
//                .foregroundColor(.black)
//        }
//    }
//}

//#Preview {
//    LoginView()
//}
