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

let sWidth = LoginView().screenWidth
let sHeight = LoginView().screenHeight


struct HomeView: View {
    
    @State var showMenu : Bool = false
    
    @State var showCheckView : Bool = false
    
    @State var showActionViews : [Bool] = [false, false, false]
    
    @State var showPauseEnd : Bool = false
    
    @State var pBeginSwipeable : Bool = true
    @State var pEndSwipeable : Bool = true
    
    
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
    
    
    @State var slideMenuOut : CGFloat = (1/2) * sWidth
    @State var slideMenuIn : CGFloat = (-(1/2) * sWidth + ((sWidth/82.8)))
    @State var slideMenu : CGFloat = (-(1/2) * sWidth + ((sWidth/82.8)))
    
    var body: some View {
        
        HStack(alignment: .center){
            
            
            SlideMenuView()
                .padding(.trailing, 70)
            
            
            VStack{
                
                
                VStack(alignment: .center, spacing: 10){
                    
                    HStack{
                        
                        Text(getDay())
                            .padding(10)
                            .background(Color.white.opacity(1/2))
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .cornerRadius(32)
                            .shadow(radius: 20)
                            .padding(.bottom, 20)
                        
                        Spacer()
                        
                    }
                    
                    Text("Aktuell bitte die App nicht aus dem Verlauf löschen, ansonsten gehen die bisher eingetragenen Daten verloren!")
                        .padding(5)
                        .background(Color.red.opacity(1/2))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                    
                    VStack{
                        if(self.showActionViews[0]) {
                            StartButtonView()
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
                                .frame(width: (5/6 * sWidth), height: (((5/6 * sWidth)-20) * 1/3), alignment: .center)
                                .background(Color.white)
                                .cornerRadius(32)
                                .padding(.bottom, 10)
                                
                                if(self.showActionViews[2]) {
                                    VStack{
                                        EndButtonView(wTime : self.$workDur)
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
                        .modifier(ButtonMod())
                        .disabled(self.showActionViews[0])
                        
                        Text("Pause")   // Button Pause Begin/End
                            .modifier(ButtonMod())
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
                                })
                        )
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
                        .modifier(ButtonMod())
                        .disabled(self.showActionViews[2])
                        
                    }
                    .frame(width: (5/6 * sWidth), height: (((5/6 * sWidth)-20) * 1/3), alignment: .center)
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
                
            }
            
            
        }
        .offset(x: self.slideMenu, y: 0)
        .navigationBarBackButtonHidden(true)
        .background(Image("SignInUp Image").scaleEffect(0.5).blur(radius: 20), alignment: .center)
        .popover(isPresented: self.$showCheckView){
            CheckView(show : self.$showCheckView, showActionViews : self.$showActionViews, showPauseEnd : self.$showPauseEnd, pBeginSwipeable: self.$pBeginSwipeable, pEndSwipeable: self.$pEndSwipeable)
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
        .onEnded{ value in
            if 0 > value.translation.width {
                print("left")
                withAnimation{
                    self.slideMenu = self.slideMenuIn
                }
            } else if 0 < value.translation.width {
                print("right")
                withAnimation{
                    self.slideMenu = self.slideMenuOut
                }
                
            }
            
        })
        
    }
    
}

public func slideIn(){
    HomeView().slideMenu = HomeView().slideMenuIn
}

public func slideOut(){
    HomeView().slideMenu = HomeView().slideMenuOut
}


struct CheckView : View {
    
    @Binding var show : Bool
    @Binding var showActionViews : [Bool]
    @Binding var showPauseEnd : Bool
    @Binding var pBeginSwipeable : Bool
    @Binding var pEndSwipeable : Bool
    
    
    @State var reportTitle : String = ""
    
    var formatString = "Format: 'hh:mm'"
    
    @State var wStart : String = offlineData.string(forKey: dataKeys.keyWorkBegin) ?? "Format: 'hh:mm'"
    @State var pStart : String = offlineData.string(forKey: dataKeys.keyPauseStart) ?? "Format: 'hh:mm'"
    @State var pEnd : String = offlineData.string(forKey: dataKeys.keyPauseEnd) ?? "Format: 'hh:mm'"
    @State var pDur : String = offlineData.string(forKey: dataKeys.keyPauseDur) ?? "Format: 'hh:mm'"
    @State var wEnd : String = offlineData.string(forKey: dataKeys.keyWorkEnd) ?? "Format: 'hh:mm'"
    @State var wDur : String = offlineData.string(forKey: dataKeys.keyWorkDur) ?? "Format: 'hh:mm'"
    
    @State var wDetailsLoc : String = "Ort/e"
    @State var wDetailsAct : String = "Tätigkeit/en"
    
    @State var wDLoc : String = "Ort/e"
    @State var wDAct : String = "Tätigkeit/en"
    
    @State var details : String = ""
    
    var body: some View {
        VStack{
            
            Text("Stimmen diese Daten?")
                .font(.largeTitle)
                .padding(.vertical, 10)
            
            Spacer()
            
            HStack{
                
                VStack{
                    
                    Text("Arbeit")
                        .font(.system(size: 35))
                    
                    HStack(alignment : .center){
                        Text("Beginn:")
                        Spacer()
                        TextField(self.wStart, text: self.$wStart)
                            .modifier(CheckTextModifier())
                    }
                    
                    
                    HStack(alignment: .center){
                        Text("Ende:")
                        Spacer()
                        TextField(self.wEnd, text: self.$wEnd)
                            .modifier(CheckTextModifier())
                    }
                    
                    
                    HStack(alignment: .center){
                        Text("Dauer:")
                        Spacer()
                        TextField(self.wDur, text: self.$wDur)
                            .modifier(CheckTextModifier())
                    }
                    
                    
                }
                .padding(7)
                .background(Color.init(.lightGray))
                .cornerRadius(16)
                
                
                VStack{
                    
                    Text("Pause")
                        .font(.system(size: 35))
                    
                    HStack(alignment : .center){
                        Text("Beginn:")
                        Spacer()
                        TextField(self.pStart, text: self.$pStart)
                            .modifier(CheckTextModifier())
                    }
                    
                    
                    HStack(alignment : .center){
                        Text("Ende:")
                        Spacer()
                        TextField(self.pEnd, text: self.$pEnd)
                            .modifier(CheckTextModifier())
                    }
                    
                    
                    HStack(alignment : .center){
                        Text("Dauer:")
                        Spacer()
                        TextField(self.pDur, text: self.$pDur)
                            .modifier(CheckTextModifier())
                    }
                    
                    
                }
                .padding(7)
                .background(Color.init(.lightGray))
                .cornerRadius(16)
                
            }
            
            
            VStack(alignment: .center){
                
                Text("Arbeitsdetails:")
                    .font(.system(size: 35))
                
                VStack(alignment: .leading){
                    Text("Ort/e:")
                    
                    TextField( self.wDLoc, text: self.$wDLoc)
                        .modifier(CheckTextFieldModifier())
                    
                }
                
                VStack(alignment: .leading){
                    Text("Tätigkeit/en:")
                    
                    TextField( self.wDAct, text: self.$wDAct)
                        .modifier(CheckTextFieldModifier())
                }
                
            }
            .padding(5)
            .background(Color.init(.lightGray))
            .cornerRadius(16)
            
            Spacer()
            
            Button(action: {
                
                offlineData.set(self.wStart, forKey: dataKeys.keyWorkBegin)
                offlineData.set(self.pStart, forKey: dataKeys.keyPauseStart)
                offlineData.set(self.pEnd, forKey: dataKeys.keyPauseEnd)
                offlineData.set(self.pDur, forKey: dataKeys.keyPauseDur)
                offlineData.set(self.wEnd, forKey: dataKeys.keyWorkEnd)
                offlineData.set(self.wDur, forKey: dataKeys.keyWorkDur)
                offlineData.set(self.wDLoc, forKey: dataKeys.keyWorkDetailsLocation)
                offlineData.set(self.wDAct, forKey: dataKeys.keyWorkDetailsActivities)

                self.details  = ((offlineData.string(forKey: dataKeys.keyWorkDetailsLocation) ?? "Ein Fehler ist aufgetreten") + (offlineData.string(forKey: dataKeys.keyWorkDetailsActivities) ??  "Ein Fehler ist aufgetreten"))

                offlineData.set(self.details, forKey: dataKeys.keyWorkDetails)
                
                
                dbQuery.createNewWorReportDoc(un: offlineData.string(forKey: dataKeys.keyUsername) ?? "Fehler - Der Username konnte nicht abgerufen weden in den UserDefaults")
                
                self.showActionViews = [false, false, false]
                self.showPauseEnd = false
                self.pBeginSwipeable = true
                self.pEndSwipeable = true
                self.show = false
            }){
                Text("Jetzt abschicken")
            }
            .padding(.bottom, 10)
            
        }
        .padding()
        .frame(width: (5/6 * sWidth))
        .background(Color.clear)
    }
}

struct CheckTextModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width : 50)
            .padding(5)
            .multilineTextAlignment(.trailing)
            .background(Color.white)
            .cornerRadius(8)
    }
}

struct CheckTextFieldModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5)
            .multilineTextAlignment(.leading)
            .background(Color.white)
            .cornerRadius(8)
    }
}

func getDay() -> String {
    let customFormatter = DateFormatter()
    customFormatter.dateFormat = "eeee, dd.MM."
    return (customFormatter.string(for: Date()) ?? "Error") as String
}

func getTime() -> String {
    let customFormatter = DateFormatter()
    customFormatter.dateFormat = "H:mm"
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
                "workDuration": offlineData.string(forKey: dataKeys.keyWorkDur) ?? "Error while writing WorkReport Data",
                "workDetails": offlineData.string(forKey: dataKeys.keyWorkDetails) ?? "Error while writing WorkReport Data"
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
    
    
    func body(content: Content) -> some View {
        content
            .frame(width: (((5/6 * sWidth)-20) * 1/3), height: (((5/6 * sWidth)-20) * 1/3))
            .background(Color.white)
            .cornerRadius(32)
            .buttonStyle(PlainButtonStyle())
    }
}

func calcPauseDur(from firstDate: Date, to secondDate: Date) -> Int{
    return (NSCalendar.current.dateComponents([.hour,.minute], from: firstDate, to: secondDate).minute ?? 0) as Int+(NSCalendar.current.dateComponents([.hour,.minute], from: firstDate, to: secondDate).minute ?? 0) as Int
}

func calcWorkDur(from firstDate: Date, to secondDate: Date, pauseDur: Int) -> Int{
    return ((NSCalendar.current.dateComponents([.hour,.minute], from: firstDate, to: secondDate).hour ?? 0) as Int + (NSCalendar.current.dateComponents([.hour,.minute], from: firstDate, to: secondDate).minute ?? 0) as Int) - pauseDur
}

struct StartButtonView : View{
    
    var body: some View {
        HStack{
            Text("Start:")
            Divider()
            Text("\(getTime())")
        }
        .frame(width: (5/6 * sWidth), height: (((5/6 * sWidth)-20) * 1/3), alignment: .center)
        .background(Color.white)
        .cornerRadius(32)
        .padding(.bottom, 10)
    }
}

struct EndButtonView : View{
    
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
        .frame(width: (5/6 * sWidth), height: (((5/6 * sWidth)-20) * 1/3), alignment: .center)
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
