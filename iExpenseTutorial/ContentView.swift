//
//  ContentView.swift
//  iExpenseTutorial
//
//  Created by Danjuma Nasiru on 14/01/2023.
//

import SwiftUI

struct Userrr : Codable {
    let firstName: String
    let lastName: String
}


class User : ObservableObject {
    @Published var firstName = "Bilbo"
    @Published var lastName = "Baggins"
}


struct SecondView : View{
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View{
        Button("Dismiss"){
            dismiss()
        }
    }
}

struct ContentView: View {
    
    //Both user defaults and appStorage do the exact same thing. appstorage requires less code, but can only hold simple data types, it can't hold structs for instance.
    //if an appstorage key does not have a value set, it uses the property's value as default. If a userdefault key does not have a value set for an integer for instance, it takes zero as its default.
    @State private var tap = UserDefaults.standard.integer(forKey: "tap")
    
    @AppStorage("tapCount") private var tapCount = 0
    
    @State private var userrr = Userrr(firstName: "Nas", lastName: "Dan")
    
    @StateObject var user = User()
    
    @State private var showSheet1 = false
    
    @State private var showSheet2 = false
    
    @State private var sample = "yeyeye"
    
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    
    var body: some View {
        
        
        NavigationView{
            VStack {
                Text("Your name is \(user.firstName) \(user.lastName).")
                
                TextField("First name", text: $user.firstName)
                TextField("Last name", text: $user.lastName)
                
                Button("tap") {
                    showSheet1.toggle()
                }
                
                Button("Tap: \(tap)") {
                    tap += 1
                    UserDefaults.standard.set(self.tap, forKey: "tap")
                }
                
                Button("Tap count: \(tapCount)") {
                    tapCount += 1
                    
                }
                
                Button("Save User"){
                    let encoder = JSONEncoder()
                    if let data = try? encoder.encode(userrr){
                        UserDefaults.standard.set(data, forKey: "UserData")
                    }
                }
                
                
                Button("Retrieva Data"){
                    let decoder = JSONDecoder()
                    guard let userrrJson = UserDefaults.standard.data(forKey: "UserData")else{
                        return
                    }
                    if let _ = try? decoder.decode(Userrr.self, from: userrrJson){
                        
                    }
                }
                
                
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }.onDelete(perform: removeRows)
                }
                
                Button("Add Number"){
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
                
            }.sheet(isPresented: $showSheet1) {
                SecondView().frame(width: 200, height: 200, alignment: .trailing)
            }
            .toolbar(content: {ToolbarItem(placement: .bottomBar, content: {EditButton()})})
        }
    }
    
    func removeRows (at offsets: IndexSet){
        numbers.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
