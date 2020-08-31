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

let offlineData = UserDefaults.standard


struct HomeView: View {
    
    @State var showCheckView : Bool = false
    
    @State var showActionViews : [Bool] = [false, false, false]
    
    @State var showPauseEnd : Bool = false
    
    @State var pBeginSwipeable : Bool = true
    @State var pEndSwipeable : Bool = true
    
    
    @State var sWidth = LoginView().screenWidth
    let sHeight = LoginView().screenHeight
    
    @State var wStart: String = offlineData.string(forKey: dataKeys.keyWorkBegin) ?? ""
    @State var pStart : String = offlineData.string(forKey: dataKeys.keyPauseStart) ?? ""
    @State var pEnd : String = offlineData.string(forKey: dataKeys.keyPauseEnd) ?? ""
    @State var wEnd : String = offlineData.string(forKey: dataKeys.keyWorkEnd) ?? ""
    
    @State var pauseDur : Int = 0
    @State var workDur : Int = 0
    
    @State var workBeginDate : Date = Date()
    @State var workEndDate : Date = Date()
    
    @State var pauseBeginDate : Date = Date()
    @State var pauseEndDate : Date = Date()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10){
            
            
            Text(getDay())
                .padding(10)
                .background(Color.white.opacity(1/2))
                .font(.largeTitle)
                .foregroundColor(.white)
                .cornerRadius(32)
                .shadow(radius: 20)
                .padding(.bottom, 20)
            
            
            VStack{
                if(self.showActionViews[0]) {
                    StartButtonView(w : self.$sWidth)
                    if(self.showActionViews[1]) {
                        
                        HStack{
                            VStack(alignment : .leading, spacing : 5){
                                HStack(spacing: 20){
                                    Text("Pause Start")
                                    Text("\(self.pStart)")
                                }
                                if(self.showPauseEnd){
                                    HStack(spacing: 20){
                                        Text("Pause Ende")
                                        Text("\(self.pEnd)")
                                    }
                                }
                            }
                            if(self.showPauseEnd){
                                Divider()
                                VStack(alignment: .leading){
                                    Text("Dauer")
                                    HStack(alignment: .center){
                                        Text("\(self.pauseDur)")
                                    }
                                }
                            }
                            
                        }
                        .frame(width: (5/6 * self.sWidth), height: (((5/6 * self.sWidth)-20) * 1/3), alignment: .center)
                        .background(Color.white)
                        .cornerRadius(32)
                        .padding(.bottom, 10)
                        
                        if(self.showActionViews[2]) {
                            VStack{
                                EndButtonView(w : self.$sWidth, wTime : self.$workDur)
                            }
                        }
                        
                    }
                }
            }
            
            Spacer()
            
            HStack{
                Button(action: {   // Button Work Start
                    self.workBeginDate = Date()
                    self.wStart = getTime()
                    offlineData.set(self.wStart, forKey : dataKeys.keyWorkBegin)
                    withAnimation{
                        self.showActionViews[0] = true
                    }
                }) {
                    Text("Start")
                }
                .modifier(ButtonMod(w : self.$sWidth))
                .disabled(self.showActionViews[0])
                
                Text("Pause")   // Button Pause Begin/End
                    .modifier(ButtonMod(w : self.$sWidth))
                    .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                        .onEnded({ value in
                            if (value.translation.width < 0) {
                                print("links")
                                if(self.pBeginSwipeable == true){
                                    self.pBeginSwipeable = false
                                    self.pStart = getTime()
                                    
                                    self.pauseBeginDate = Date()
                                    withAnimation{
                                        self.showActionViews[1] = true
                                    }
                                    offlineData.set(self.pStart, forKey : dataKeys.keyPauseStart)
                                }
                            } else if (value.translation.width > 0) {
                                print("rechts")
                                if(self.pEndSwipeable == true && self.pBeginSwipeable == false){
                                    self.pEnd = getTime()
                                    offlineData.set(self.pEnd, forKey : dataKeys.keyPauseEnd)
                                    self.pauseEndDate = Date()
                                    self.pauseDur =  calcPauseDur(from: self.pauseBeginDate, to: self.pauseEndDate)
                                    offlineData.set("\(self.pauseDur)", forKey : dataKeys.keyPauseDur)
                                    withAnimation{
                                        self.showPauseEnd = true
                                    }
                                    self.pEndSwipeable = false
                                }
                            }
                        }))
                    .disabled(self.showPauseEnd)
                
                Button(action: {    // Button Work End
                    self.workEndDate = Date()
                    self.wEnd = getTime()
                    offlineData.set(self.wEnd, forKey : dataKeys.keyWorkEnd)
                    withAnimation{
                        self.showActionViews[2] = true
                    }
                    self.workDur = calcWorkDur(from: self.workBeginDate, to: self.workEndDate, pauseDur: self.pauseDur)
                    offlineData.set("\(self.workDur)", forKey : dataKeys.keyWorkDur)
                }) {
                    Text("Ende")
                }
                .modifier(ButtonMod(w : self.$sWidth))
                .disabled(self.showActionViews[2])
            }
            .frame(width: (5/6 * self.sWidth), height: (((5/6 * self.sWidth)-20) * 1/3), alignment: .center)
            .padding(.bottom, 10)
            
            HStack(alignment : .center){
                if(self.showActionViews[2]) {
                    Button(action: {
                        self.showCheckView = true
                    }){
                        Text("Daten abschicken?")
                    }
                    .padding(10)
                    .background(Color.white.opacity(1/2))
                    .foregroundColor(.white)
                    .cornerRadius(32)
                    .shadow(radius: 20)
                }
            }.padding(.bottom, 30)
            
        }
        .navigationBarBackButtonHidden(true)
        .background(Image("SignInUp Image").scaleEffect(0.5), alignment: .center)
        .popover(isPresented: self.$showCheckView){
            CheckView(show : self.$showCheckView, showActionViews : self.$showActionViews, showPauseEnd : self.$showPauseEnd, pBeginSwipeable: self.$pBeginSwipeable, pEndSwipeable: self.$pEndSwipeable)
        }
        
    }
}

struct CheckView : View {
    
    @Binding var show : Bool
    @Binding var showActionViews : [Bool]
    @Binding var showPauseEnd : Bool
    @Binding var pBeginSwipeable : Bool
    @Binding var pEndSwipeable : Bool
    
    var body: some View {
        VStack{
            Text("Stimmen diese Daten?")
            HStack{
                Text("TextField")
                Image(systemName : "pencil")
            }
            HStack{
                Text("TextField")
                Image(systemName : "pencil")
            }
            HStack{
                Text("TextField")
                Image(systemName : "pencil")
            }
            HStack{
                Text("TextField")
                Image(systemName : "pencil")
            }
            Button(action: {
                dbQuery.createNewWorReportDoc(un: offlineData.string(forKey: dataKeys.keyUsername) ?? "Fehler - Der Username konnte nicht abgerufen weden in den UserDefaults")
                
                self.showActionViews = [false, false, false]
                self.showPauseEnd = false
                self.pBeginSwipeable = true
                self.pEndSwipeable = true
                self.show = false
            }){
                Text("Jetzt abschicken")
            }
        }
    }
}

func getDay() -> String {
    let customFormatter = DateFormatter()
    customFormatter.dateFormat = "eeee, dd.MM."
    return (customFormatter.string(for: Date()) ?? "Error") as String
}

func getTime() -> String {
    let customFormatter = DateFormatter()
    customFormatter.dateFormat = "H:mm:ss"
    return (customFormatter.string(for: Date()) ?? "Error") as String
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

class ReadWriteData {
    
    func createNewWorReportDoc(un : String) {
        //print("User/\(un)/workReport/\(getDay())/")   //Debug
        let docData: [String: Any] =
            [
                "pauseBegin": offlineData.string(forKey: dataKeys.keyPauseStart) ?? "Error while writing WorkReport Data",
                "pauseEnd": offlineData.string(forKey: dataKeys.keyPauseEnd) ?? "Error while writing WorkReport Data",
                "pauseDuration": offlineData.integer(forKey: dataKeys.keyPauseDur),
                "timeDocAdded": Timestamp.init(),
                "workBegin": offlineData.string(forKey: dataKeys.keyWorkBegin) ?? "Error while writing WorkReport Data",
                "workEnd": offlineData.string(forKey: dataKeys.keyWorkEnd) ?? "Error while writing WorkReport Data",
                "workDuration": offlineData.string(forKey: dataKeys.keyWorkDur) ?? "Error while writing WorkReport Data"
        ]
        
        db.collection("User").document(un).collection("workReport").document(getDay()).setData(docData) { err in
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
            .frame(width: (((5/6 * self.w)-20) * 1/3), height: (((5/6 * self.w)-20) * 1/3))
            .background(Color.white)
            .cornerRadius(32)
    }
}

func calcPauseDur(from firstDate: Date, to secondDate: Date) -> Int{
    return (NSCalendar.current.dateComponents([.hour,.minute], from: firstDate, to: secondDate).minute ?? 0) as Int+(NSCalendar.current.dateComponents([.hour,.minute], from: firstDate, to: secondDate).minute ?? 0) as Int
}

func calcWorkDur(from firstDate: Date, to secondDate: Date, pauseDur: Int) -> Int{
    return ((NSCalendar.current.dateComponents([.hour,.minute], from: firstDate, to: secondDate).hour ?? 0) as Int + (NSCalendar.current.dateComponents([.hour,.minute], from: firstDate, to: secondDate).minute ?? 0) as Int) - pauseDur
}

struct StartButtonView : View{
    @Binding var w : CGFloat
    var body: some View {
        HStack{
            Text("Start:")
            Divider()
            Text("\(getTime())")
        }
        .frame(width: (5/6 * w), height: (((5/6 * w)-20) * 1/3), alignment: .center)
        .background(Color.white)
        .cornerRadius(32)
        .padding(.bottom, 10)
    }
}

struct EndButtonView : View{
    @Binding var w : CGFloat
    @Binding var wTime : Int
    var body: some View {
        VStack{
            HStack{
                Text("Ende:")
                
                Text("\(getTime())")
            }
            Divider()
            HStack{
                Text("Arbeitszeit:")
                
                Text("\(wTime)")
            }
            
        }
        .frame(width: (5/6 * w), height: (((5/6 * w)-20) * 1/3), alignment: .center)
        .background(Color.white)
        .cornerRadius(32)
    }
}

func debugUserDefaults(){
    print("keySActionV0 ->",offlineData.bool(forKey: dataKeys.keySActionV0))
    print("keySActionV1 ->",offlineData.bool(forKey: dataKeys.keySActionV1))
    print("keySActionV2 ->",offlineData.bool(forKey: dataKeys.keySActionV2))
    print("keySPauseE ->",offlineData.bool(forKey: dataKeys.keySPauseE))
    print("keyPauseSwpieB ->",offlineData.bool(forKey: dataKeys.keyPauseSwpieB))
    print("keyPauseSwpieE ->",offlineData.bool(forKey: dataKeys.keyPauseSwpieE))
}
