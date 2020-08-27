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
    
    var body: some View {
     
        VStack{
            Spacer()
            SlideMenuView()
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userId: Binding.constant("Hello"))
    }
}
