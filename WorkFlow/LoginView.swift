//
//  ContentView.swift
//  WorkFlow
//
//  Created by Soustronic  on 26.08.20.
//  Copyright © 2020 WideNetwork. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

let db = Firestore.firestore()

let dbQuerys = DataBaseQuerys()

struct LoginView: View {
    
    var screenWidth : CGFloat = UIScreen.main.bounds.width
    var screenHeight : CGFloat = UIScreen.main.bounds.height
    
    @State var userExists : Bool = true
    
    @State var username : String = ""
    @State var password : String = ""
    @State var confirmPass : String = ""
    
    @State var resultText : String = " "
    
    
    @State var showPopover: Bool = false
    @State var passwordEqual : Bool = false
    
    @State var loginSuccsess : Bool = false
    
    @State var animate : Bool = false
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                Image("SignInUp Image")
                    .frame(width: 360, height: 200, alignment: .center)
                    .scaleEffect(4/10)
                    .mask(Text("WorkFlow")
                        .padding()
                        .font(Font.system(size: 72).weight(.semibold)))
                    .saturation(2)
                    .colorInvert()
                
                Spacer()
                
                if(self.animate){
                    LoadingOverlay(animate: self.$animate)
                }
                
                Spacer()
                
                VStack{
                    UsernameTextField(username : $username)
                    
                    PasswordSecureField(password: $password)
                }
                
                Result(resultText: self.$resultText)
                
                NavigationLink(destination: HomeView(), isActive: $loginSuccsess ) { EmptyView() }
                
                Button(action: {
                    self.animate = true
                    Auth.auth().signIn(withEmail: self.username, password: self.password) { authResult, error in
                        if (error == nil && authResult != nil) {
                            if(!self.userExists){
                                dbQuerys.createUserInformationDoc(usermail: self.username)
                            }
                            print("Login Succsess")
                            self.animate = false
                            self.loginSuccsess = true
                        } else if (error != nil && authResult == nil) {
                            self.resultText = errorDebugFunction(errDesc: error.debugDescription)
                            print("Login failed")
                            self.animate = false
                            self.loginSuccsess = false
                        }
                    }
                }){
                    LoginButtonContext()
                }
                
                Spacer()
                
                VStack(alignment: .center){
                    
                    VStack(alignment: .center){
                        Image(systemName: "chevron.compact.up")
                            .foregroundColor(Color.white.opacity(1/1))
                            .scaleEffect(2)
                        
                    }
                    
                    HStack{
                        
                        Text("Kein Account?")
                            .foregroundColor(.black)
                            .gesture(DragGesture(minimumDistance: 30, coordinateSpace: .local)
                                .onEnded({ value in
                                    if value.translation.height < 0 {
                                        self.showPopover.toggle()
                                    }
                                }))
                        
                    }
                    .frame(width: 130, height: 30, alignment: .center)
                    .background(Color.white.opacity(1/2))
                    .cornerRadius(32)
                }
                
            }
            .background(
                Image("SignInUp Image")
                    .frame(width: 1242, height: 2688, alignment: .center)
                    .scaleEffect(4/10))
                .popover(
                    isPresented: self.$showPopover
                ){
                    SignUpView(username: self.$username, password: self.$password, confirmPass: self.$confirmPass, showPopover: self.$showPopover, passwordEqual: self.$passwordEqual, userExists: self.$userExists, resultText: self.$resultText)
                    
            }
        }
    }
}

class DataBaseQuerys {
    
    func getErrorMessage(sortedBy: String) {
        
        var desiredProperty: String!
        
        db.collection("UnknownErrorMessages").order(by: sortedBy, descending: true).limit(to: 1).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let nameOfPropertyIwantToRetrieve = "errorMessage"
                    
                    if let selectedProperty = document.data()[nameOfPropertyIwantToRetrieve] {
                        desiredProperty = selectedProperty as? String
                    }
                    
                    //The result from 'nameOfPropertyIwantToRetrieve'
                    print(desiredProperty.description)
                    
                    
                }
            }
            
        }
        
    }
    
    func createNewErrorDoc(errMessage : String) {
        
        db.collection("UnknownErrorMessages").document().setData([
            "errorMessage": errMessage,
            "occureTime": Timestamp.init(),
            "read": false
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    func createUserInformationDoc(usermail: String) {
        
        db.collection("User").document().setData([
            "lastLogIn": Timestamp.init(),
            "signedUp": Timestamp.init(),
            "usermail": usermail.lowercased()
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}

func errorDebugFunction(errDesc : String) -> String {
    
    print("Error ",errDesc)
    
    if (errDesc.contains("Code=17020")) {
        return  "Network error has occured. Check your internet connection."
    } else if(errDesc.contains("Code=17007")){
        return  "The email address is already in use by another account."
    } else if (errDesc.contains("Code=17008")) {
        return  "The email adress is baly formatted."
    } else if (errDesc.contains("Code=17026")) {
        return  "The password must be 6 characters long or more."
    } else if (errDesc.contains("Code=17009") || errDesc.contains("Code=17011")) {
        return  "The password or email is invalide."
    }  else if(errDesc.contains("Code=17020")) {
        return  "Network error has occured. Check your internet connection."
    } else {
        dbQuerys.createNewErrorDoc(errMessage: errDesc.debugDescription)
        return "An unknown error occured. Please restart the app!"
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct UsernameTextField: View {
    @Binding var username : String
    var body: some View {
        ZStack{
            
            Text("")
                .frame(width: 325,height: 27)
                .padding()
                .background(Color.gray.blur(radius: 6))
                .cornerRadius(32.0)
                .padding(.bottom, 10)
                .padding(.horizontal,30)
            
            TextField("Email", text: $username)
                .frame(width: 320,height: 22)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(32.0)
                .padding(.bottom, 10)
                .padding(.horizontal,30)
            
            
        }
    }
}

struct PasswordSecureField: View {
    @Binding var password : String
    var body: some View {
        ZStack{
            
            Text("")
                .frame(width: 325,height: 27)
                .padding()
                .background(Color.gray.blur(radius: 6))
                .cornerRadius(32.0)
                .padding(.bottom, 10)
                .padding(.horizontal,30)
            
            TextField("Password", text: $password)
                .frame(width: 320,height: 22)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(32.0)
                .padding(.bottom, 10)
                .padding(.horizontal,30)
            
        }
    }
}

struct ConfirmPassField: View {
    @Binding var confirmPass : String
    var body: some View {
        
        ZStack{
            
            Text("")
                .frame(width: 325,height: 27)
                .padding()
                .background(Color.gray.blur(radius: 6))
                .cornerRadius(32.0)
                .padding(.bottom, 10)
                .padding(.horizontal,30)
            
            TextField("Password", text: $confirmPass)
                .frame(width: 320,height: 22)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(32.0)
                .padding(.bottom, 10)
                .padding(.horizontal,30)
            
        }
    }
}

struct LoginButtonContext : View {
    var body: some View {
        return
            Text("LOGIN")
                .font(.headline)
                .foregroundColor(Color.black)
                .padding()
                .frame(width: 240, height: 40)
                .background(Color.init(red: 225/256, green: 171/256, blue: 99/256).blur(radius: 12/20))
                .cornerRadius(32.0)
        
        
        
    }
}

struct SignUpButtonText : View {
    var body: some View {
        return Text("Sign Up")
            .font(.headline)
            .foregroundColor(Color.black)
            .padding()
            .frame(width: 240, height: 40)
            .background(Color.init(red: 225/256, green: 171/256, blue: 99/256).blur(radius: 12/20))
            .cornerRadius(32.0)
    }
}

struct SignUpView: View {
    
    @Binding var username : String
    @Binding var password : String
    @Binding var confirmPass : String
    @Binding var showPopover: Bool
    @Binding var passwordEqual: Bool
    @Binding var userExists : Bool
    
    @Binding var resultText : String
    
    
    var body: some View {
        VStack{
            
            Text("Registriere dich hier")
                .font(.largeTitle)
                .bold()
                .padding(.top, 30)
            
            Divider()
            
            UsernameTextField(username: self.$username)
                .padding(.top, 100)
            PasswordSecureField(password: self.$password)
            ConfirmPassField(confirmPass: self.$confirmPass)
            
            Result(resultText: self.$resultText)
            
            SignUpButtonText()
                .onTapGesture {
                    if(self.confirmPass.elementsEqual(self.password)){
                        self.showPopover = true
                        Auth.auth().createUser(withEmail: self.username, password: self.password) { authResult, error in
                            if (error != nil && authResult == nil) {
                                self.resultText = errorDebugFunction(errDesc: error.debugDescription)
                            } else if (error == nil && authResult != nil) {
                                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                    
                                })
                                self.userExists = false
                                self.showPopover = false
                            }
                        }
                    } else {
                        print("Password does not match")
                        self.resultText = "Password doesn't match"
                    }
            }
            
            Spacer()
        }
        .gesture(DragGesture(minimumDistance: 30, coordinateSpace: .local)
        .onEnded({ value in
            if value.translation.height > 0 {
                self.showPopover.toggle()
            } else {}
        }))
    }
    
}

struct LoadingOverlay: View{
    
    @Binding var animate : Bool
    
    var body: some View {
        
        return ZStack{
            
            VStack{
                
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(AngularGradient(gradient: .init(colors: [.clear,.white]), center: .center),style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .frame(width: 45, height: 45)
                    .rotationEffect(.init(degrees: animate ? 360 : 0))
                    .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
                
                Text("Open Database.. ")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.top, 30)
                
            }
            .frame(width: 200, height: 200)
            .background(Color.white.opacity(3/10).blur(radius: 1, opaque: false))
            .cornerRadius(32)
            
        }
        .frame(width: 500, height: 990)
    }
    
}

struct Result : View{
    
    @Binding var resultText : String
    
    var body: some View {
        
        return Text(resultText)
            .bold()
            .background(Color.white.opacity(1/2))
            .foregroundColor(.red)
            .cornerRadius(3)
            .padding(.bottom, 2)
            .padding(.bottom, 6)
            
        
    }
}
