//
//  ContentView.swift
//  CoreDataExampleApp
//
//  Created by Krefting, Max (PGW) on 12/03/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingAddToBillView = false
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Food.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Food.meal, ascending: false)])
    var food: FetchedResults<Food>
    
    func removeBill(){
        //
    }
    
    var body: some View {
        
        NavigationView{
            List{
                ForEach(self.food, id: \.self){ food in
                HStack{
                    Text("Food Name: \(food.foodName ?? "NA")")
                    Spacer()
                    VStack{
                        Text("Meal: \(food.meal ?? "NA")")
                        Spacer()
                        Text("Calories: \(food.calories)")
                        Spacer()
                        NavigationLink(destination: ViewAndEditView(foodObject: food), label: {Text("View/Edit Item")})
                        Spacer()
                    }
                }
                    
                }.onDelete(perform: {indexSet in
                    for index in indexSet{
                        managedObjectContext.delete(food[index])
                    }
                    do{
                        try managedObjectContext.save()
                    } catch {
                        print("Error")
                    }
                })
            }// list end
            .navigationBarTitle("Foods",displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(
                                        action:{self.showingAddToBillView.toggle()}
                                    ){Image(systemName:"plus")}
                .sheet(isPresented:$showingAddToBillView){AddToBillView()}
            )
        }
    }
}
