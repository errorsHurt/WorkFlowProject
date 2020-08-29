//
//  HomeView.swift
//  WorkFlow
//
//  Created by Soustronic  on 27.08.20.
//  Copyright © 2020 WideNetwork. All rights reserved.
//

import SwiftUI

//screenWidth : CGFloat = UIScreen.main.bounds.width
//screenHeight : CGFloat = UIScreen.main.bounds.height

struct HomeView: View {
    
    let sWidth = LoginView().screenWidth
    let sHeight = LoginView().screenHeight
    
    @Binding var userId : String
    
    @State var showMenu: CGFloat = -215
    
    @State var blurBackground : CGFloat = 0
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                Text("Moin")
            }
            
            
            
            
            
            
            
        }
        .frame(width: self.sWidth, height: self.sHeight)
        .background(Image("SignInUp Image"))
        .navigationBarBackButtonHidden(true)
        .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
        .onEnded(){ value in
            if value.translation.width > 0 {
                withAnimation{
                    self.blurBackground = 30
                    self.showMenu = 184
                }
            } else {
                withAnimation{
                    self.blurBackground = 0
                    self.showMenu = -215
                }
            }
            
        })
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userId: Binding.constant("Hello"))
    }
}
