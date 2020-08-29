//
//  HomeView.swift
//  WorkFlow
//
//  Created by Soustronic  on 27.08.20.
//  Copyright © 2020 WideNetwork. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct HomeView: View {
    
    let sWidth = LoginView().screenWidth
    let sHeight = LoginView().screenHeight
    
    @State var clickCounter : Int = 0
    
    var body: some View {
        
        Group{
            
            VStack(alignment: .center, spacing: 10){
                
                HStack{
                    
                    Text("start")
                    .frame(width: (1/3 * self.sWidth), height: (1/3 * self.sWidth), alignment: .center)
                    .background(Color.white)
                    .cornerRadius(32)
                    
                }
                
                HStack{
                    
                    Button(action: {
                        
                    }) {
                        Text("Start")
                    }
                    .frame(width: (1/3 * self.sWidth), height: (1/5 * self.sWidth), alignment: .center)
                    .background(Color.white)
                    .cornerRadius(32)
                }
                
            }
            
        }
        .background(Image("SignInUp Image").scaleEffect(0.5), alignment: .center)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
