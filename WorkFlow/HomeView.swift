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

let dbQuery = ReadWriteData()


struct HomeView: View {
    
    @State var pauseBegin : Date = Date()
    @State var pauseEnd : Date = Date()
    @State var pauseDur : Int = 0
    
    @State var sWidth = LoginView().screenWidth
    let sHeight = LoginView().screenHeight
    
    @State var username : String
    
    @State var text : Int = 0
    
    
    
    
    var body: some View {
        
        Group{
            
            VStack(alignment: .center, spacing: 10){
                
                HStack{
                    
                    Text("\(self.text)")
                    
                    
                }
                .frame(width: (5/6 * self.sWidth), height: (1/3 * self.sWidth), alignment: .center)
                .background(Color.white)
                .cornerRadius(32)
                
                HStack{
                    
                    Button(action: {
                        
                    }) {
                        Text("start")
                    }
                    .modifier(ButtonMod(w : self.$sWidth))
                    
                    
                    Text("Pause")
                        .modifier(ButtonMod(w : self.$sWidth))
                        .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                            .onEnded({ value in
                                if value.translation.width < 0 {
                                    //self.text = "Pausenbeginn"
                                    print("links")
                                    self.pauseBegin = Date()
                                } else if value.translation.width > 0 {
                                    //self.text = "Pausenende"
                                    print("rechts")
                                    self.pauseEnd = Date()
                                    self.text =  calcPauseDur(from: self.pauseBegin, to: self.pauseEnd)
                                    
                                    
                                    
                                }
                            }))
                    
                    
                    Button(action: {
                        
                    }) {
                        Text("Ende")
                    }
                    .modifier(ButtonMod(w : self.$sWidth))
                    
                }
                .frame(width: (5/6 * self.sWidth), height: (1/3 * self.sWidth), alignment: .center)
                
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .background(Image("SignInUp Image").scaleEffect(0.5), alignment: .center)
        
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(username: "maximilianelias.meier@web.de")
    }
}

class ReadWriteData {
    
    func saveDate(){
        
    }
    
    func getPauseBeginDate() {
        
        var desiredProperty: String!
        
        db.collection("Company").getDocuments() { (querySnapshot, err) in
            if let err = err {
                
                print("QSnapchot -> ",querySnapshot)
                print("Error -> ",err)
                
                //print("Error getting documents: \(err)")
            } else {
                
                print("QSnapchot -> ",querySnapshot)
                print("Error -> ",err)
                
                let nameOfPropertyIwantToRetrieve = "ceo"
                
                for document in querySnapshot!.documents {
                    if let selectedProperty = document.data()[nameOfPropertyIwantToRetrieve] {
                        desiredProperty = selectedProperty as? String
                    }
                    //The result from 'nameOfPropertyIwantToRetrieve'
                    print("print -> ",desiredProperty.description)
                    //print(document.data())
                    
                    
                }
                
            }
            
            
        }
        
    }
    
    func createNewWorReportDoc(un : String) {
        
        var uid = Auth.auth().currentUser?.uid as? String ?? ""
        
        let docData: [String: Any] =
            [
                "pauseBegin": Timestamp.init(),
                "pauseDuration": 60,
                "timeDocAdded": Timestamp.init(),
                "workBegin": Timestamp.init(),
                "workEnd": Timestamp.init()
        ]
        db
        
        db.collection("User").document(un).collection("workReport").document("\(Date())").setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
}

struct ButtonMod: ViewModifier {
    
    @Binding var w : CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: ((5/6 * self.w) * 1/3), height: 100)
            .background(Color.white)
            .cornerRadius(32)
        
        
    }
}

func calcPauseDur(from firstDate: Date, to secondDate: Date) -> Int{
    return (NSCalendar.current.dateComponents([.hour,.minute], from: firstDate, to: secondDate).hour ?? 0) as Int + (NSCalendar.current.dateComponents([.hour,.minute], from: firstDate, to: secondDate).minute ?? 0) as Int
}

