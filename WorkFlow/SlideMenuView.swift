//
//  SlideMenuView.swift
//  WorkFlow
//
//  Created by Soustronic  on 27.08.20.
//  Copyright © 2020 WideNetwork. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SlideMenuView: View {
    
    let sWidth = LoginView().screenWidth
    let sHeight = LoginView().screenHeight
    
    var body: some View {
        
        VStack(alignment: .center){
            
            HStack(alignment: .center, spacing: 10){ //First Element
                
                VStack(alignment: .leading){
                    
                    Text("Username")
                    Text("Company?")
                    
                    
                }
                .fixedSize()
                
                
                Image(systemName: "person")
                    .padding(20)
                    .background(Color.gray)
                    .clipShape(Circle())
                
                
            }
            .padding(10)
            
            
            Divider()
            
            
            Button(action: {}){
                Text("Settings")
            }
            .frame(width: (3/4 * self.sWidth), height: 50)
            
            
            Divider()
            
            
            Button(action: {
                
            }){
                Text("Log Out")
            }
            .frame(width: (3/4 * self.sWidth), height: 50)
            
            
        }
        .scaledToFit()
        .frame(width: (3/4 * self.sWidth), height: self.sHeight)
        .background(Color.red.opacity(1/2))
        
        
        
    }
}

struct SlideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SlideMenuView()
    }
}


