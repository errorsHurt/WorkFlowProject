//
//  SlideMenuView.swift
//  WorkFlow
//
//  Created by Soustronic  on 02.09.20.
//  Copyright © 2020 WideNetwork. All rights reserved.
//

import SwiftUI

struct SlideMenuView: View {
    
    @State var ex : Int = 2
    
    @State var ntoActive : Bool = false
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10){
            
            HStack{
                
                //Userinfos
                VStack(alignment : .leading){
                    Text("\(offlineData.string(forKey: dataKeys.keyUsername) ?? "Error")")
                    
                    Text("\(offlineData.string(forKey: dataKeys.keyCompanyName) ?? "No company")")
                    
                }
                .padding(.leading, 16)
                
                Spacer()
                
                //Profilbild
                ZStack{
                    
                    Image(systemName : "person")
                        .padding(31)
                        .background(Color.black)
                        .clipShape(Circle())
                    
                    Image(systemName : "person")
                        .padding(30)
                        .background(Color.init(.lightGray))
                        .clipShape(Circle())
                    
                }
                .padding(.trailing, 16)
                
            }
            .frame(width: ((4/5) * sWidth), height: ((2/20) * sHeight))
            .background(Color.white.opacity(1/2))
            .foregroundColor(.white)
            .cornerRadius(16)
            
//            NavigationLink(destination: ReportFolderView(), isActive: self.$ntoActive) {
//                Text("Reports")
//                    .foregroundColor(.white)
//            }
//            .modifier(MenuItemModifier())
//            
//            NavigationLink(destination: EmptyView(), isActive: self.$ntoActive  ) {
//                Text("Settings")
//                    .foregroundColor(.white)
//            }
//            .modifier(MenuItemModifier())
            
            Spacer()
            
            
        }
        .frame(width: ((4/5)*sWidth))
        .background(Color.clear)
    }
}

struct SlideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SlideMenuView()
    }
}

struct MenuItemModifier : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: ((4/5) * sWidth), height: ((1/20) * sHeight))
            .background(Color.white.opacity(1/2))
            .foregroundColor(.white)
            .cornerRadius(16)
            
    }
}
