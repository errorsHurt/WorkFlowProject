//
//  InterActionView.swift
//  WorkFlow
//
//  Created by Soustronic  on 28.08.20.
//  Copyright © 2020 WideNetwork. All rights reserved.
//

import SwiftUI

struct InterActionView: View {
    var body: some View {
        
        VStack{
            
            HStack{
                
                Button(action: {}){
                    Text("Start")
                }
                
                
                Button(action: {}){
                    Text("Pause")
                }
                
                Button(action: {}){
                    Text("Stop")
                }
            }
            
            
        }
        .frame(width : 350, height : 800)
        .background(Color.white.opacity(1/2))
    .cornerRadius(32)
    }
}

struct InterActionView_Previews: PreviewProvider {
    static var previews: some View {
        InterActionView()
    }
}
