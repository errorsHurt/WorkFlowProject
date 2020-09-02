//
//  ReportFolderView.swift
//  WorkFlow
//
//  Created by Soustronic  on 02.09.20.
//  Copyright © 2020 WideNetwork. All rights reserved.
//

import SwiftUI

struct ReportFolderView: View {
    
    var reports : [String]
    
    
    
    var body: some View {
        
        VStack{
            Text("Hey")
        }
        
    }
}

struct ReportFolderView_Previews: PreviewProvider {
    static var previews: some View {
        ReportFolderView(reports: ["Das", "ist", "ein", "Beispiel"])
    }
}
