//
//  HomeView.swift
//  WorkFlow
//
//  Created by Soustronic  on 27.08.20.
//  Copyright © 2020 WideNetwork. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var userId : String
    
    @State var showMenu: CGFloat = -275
    
    @State var blurBackground : CGFloat = 0
    
    var body: some View {
        
        ZStack{
            
            Image("SignInUp Image")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.23)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 8)
            
            ZStack{
                
               InterActionView()
                .blur(radius: self.blurBackground)
                
                Group{ //Overlay
                    SlideMenuView()
                        .offset(x: self.showMenu, y: 0)
                }
                
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
        .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
        .onEnded(){ value in
            if value.translation.width > 0 {
                withAnimation{
                    self.blurBackground = 30
                    self.showMenu = 0
                }
            } else {
                withAnimation{
                    self.blurBackground = 0
                    self.showMenu = -275
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
