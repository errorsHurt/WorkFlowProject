//
//  SlideMenuView.swift
//  WorkFlow
//
//  Created by Soustronic  on 02.09.20.
//  Copyright © 2020 WideNetwork. All rights reserved.
//

import SwiftUI

struct SlideMenuView: View {
    
    //@State var accessReportFolder : Bool = false
    
    @State var ex : Int = 2
    
    var body: some View {
        
        VStack{
            
            HStack{
                Text("Menu")
            }
            
            Divider()
            
            HStack{
                
                VStack{
                    Text("\(offlineData.string(forKey: dataKeys.keyUsername) ?? "Error")")
                    
                    //Text("\(offlineData.string(forKey: dataKeys.keyCompanyName) ?? "")")
                    
                }
                
                //prfilbild
                ZStack{
                    
                    Image(systemName : "person")
                        .padding(18)
                        .background(Color.black)
                        .clipShape(Circle())
                    
                    Image(systemName : "person")
                        .padding()
                        .background(Color.init(.lightGray))
                        .clipShape(Circle())
                }
                
                
                
                
                
                
            }
            
            Divider()
            
            NavigationLink(destination: ReportFolderView(reports : ["hehe", "huhuh"])) {
                
                Button(action: {
                    //Load report data from firebase from last 30 days
                    
                }){
                    Text("Reports")
                }
            }
            
            Divider()
        }
        
    }
}

struct SlideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SlideMenuView()
    }
}
