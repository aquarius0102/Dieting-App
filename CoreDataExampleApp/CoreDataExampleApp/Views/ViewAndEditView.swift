//
//  ViewAndEditView.swift
//  CoreDataExampleApp
//
//  Created by Krefting, Max (PGW) on 23/04/2021.
//

import SwiftUI

struct ViewAndEditView: View {
    
    @Environment(\.presentationMode) var present
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var foodName: String = ""
    @State private var meal: String = ""
    @State private var calories: Double = 0
    @State private var showAlert: Bool = false
    
    let meals = ["Breakfast","Lunch","Dinner","Snacks"]
    var foodObject: Food
    
    
    func setup(){
        //studentName = billItem.studentName ?? ""
        //block = billItem.block ?? ""
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    TextField("Food Name: ", text: $foodName)
                    Picker("Meal",selection: $meal){
                        ForEach(meals, id: \.self){
                            Text($0)
                        }
                    }.pickerStyle(WheelPickerStyle())
                    
                    Slider(value: $calories, in: 0...2000)
                    
                    Button("Add Item", action:{
                        if self.foodName != "" && self.meal != ""{
                            let foodItem = Food(context: self.managedObjectContext)
                            foodItem.foodName = self.foodName
                            foodItem.meal = self.meal
                            foodItem.calories = self.calories
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                        } else {
                            self.showAlert = true
                            return
                        }
                        self.present.wrappedValue.dismiss()
                        managedObjectContext.delete(foodObject)
                    })
                    .alert(isPresented: self.$showAlert){
                        Alert(title:Text("Incomplete form"), message: Text("Please enter all data"), dismissButton: .default(Text("OK")))
                    }
                }
                Spacer()
            }
            .navigationBarTitle("New Bill Details", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action:{
                                        self.present.wrappedValue.dismiss()
                                    }){Image(systemName:"xmark")}
            )
        }
    }
}
