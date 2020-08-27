//
//  SignUpView.swift
//  WorkFlow
//
//  Created by Soustronic  on 26.08.20.
//  Copyright © 2020 WideNetwork. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @State var username: String = ""
    @State var password : String = ""
    @State var confirmPass : String = ""
    
    
    var body: some View {
        
        VStack(alignment: .center){
            
            UsernameTextField(username: $username)
            PasswordSecureField(password: $password)
            ConfirmPasswordSecureField(confirmPass: $confirmPass)
        }
        .frame(width: 423, height: 350, alignment: .center)
        .background(Color.white.opacity(1/2))
        .cornerRadius(32)
        
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

struct ConfirmPasswordSecureField: View {
    @Binding var confirmPass : String
    var body: some View {
        SecureField("Confirm Password", text: $confirmPass)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(32.0)
            .padding(.bottom, 10)
            .padding(.horizontal,30)
            .shadow(radius: 15)
        
    }
}


