//
//  HomeView.swift
//  Habit Tracker
//
//  Created by Finlay Carson Moretti on 11/08/2023.
//

// Importing SwiftUI to create user interface
// Importing Foundation for basic Date functions etc.
// Importing SwiftData to import and display database contents
// Importing SwiftUICharts to generate lovely visuals of user progress based on CompletionHistory

import SwiftUI
import Foundation
import SwiftData
import SwiftUICharts


struct HomeView: View {
    
    //Setting up link "context" to the persistent storage. A bridge between this view and the actual database.
    @Environment(\.modelContext) private var context
    
    //Query the database and get entry from it in the form of an array
    @Query private var habit: [HabitTest]
    @Query private var basicHabit: [BasicHabit]
    @Query private var history: [CompletionHistory]
    
    //Setting up a userdefaults string for the user's name and init. variable nameChangeValue for the name change UI field
    @State private var userName = UserDefaults.standard.string(forKey: "Name")
    @State private var nameChangeValue = ""
    
    //Get a random quote from Motivationals.swift
    @State private var randomQuote = randQuote()
    
    @State private var activeHabitUUID = UserDefaults.standard.string(forKey: "ActiveUUID")
    
    //init. a visibility parameter for the name change popup
    @State private var showEditAlert = false
    
    @State private var showNotificationDebug = false
    
    func getChartArray() -> Array<Double>{
        var returnArray = [Double]()
        let arraySlice = history.suffix(7)
        var counter = 0
        
        for item in arraySlice{
            counter = 0
            
            for _ in item.habits{
                counter = counter + 1
            }
            
            returnArray.append(Double(counter))
        }
        
        return returnArray
    }

    
    
    var body: some View {
        
        
        NavigationView{
            //Wrap everything in a navigation view so we can go to different pages and come back to this one after
            
            ScrollView{
                //Wrap everything in a scroll view so we can scroll through all the habits that get added
                
                
                VStack(alignment: .leading) {
                    
                    VStack{
                        
                        HStack(alignment: .top){
                            
                            VStack(alignment: .leading){
                                Text(getDateString())
                                    .font(.title3.width(.condensed))
                                    .tracking(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                                Text("Welcome back,\n\(userName ?? "No Name")")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Button("Edit") {
                                showEditAlert = true
                            }
                            .padding(10)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(13.0)
                            .alert("Customise Home Area", isPresented: $showEditAlert){
                                TextField("Change Name", text: $nameChangeValue)
                                
                                Button("Cancel", role:.destructive) {
                                }
                                
                                Button("Save", role:.cancel) {
                                    
                                    userName = nameChangeValue
                                    UserDefaults.standard.set(userName, forKey: "Name")
                                }
                            }
                        }
                        
                        HStack(alignment: .center){
                            Spacer()
                            Image(systemName: "quote.opening")
                                .padding(.top, 10.0)
                                .font(.largeTitle)
                            Text(randomQuote)
                                .font(.body)
                            
                            //.font(Font.custom("Times New Roman", size: 20).bold())
                                .fontWeight(.medium)
                                .padding(.top, 15.0)
                            Spacer()
                        }
                        .padding(.bottom)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.0, brightness: 0.0, opacity: 0.067)/*@END_MENU_TOKEN@*/)
                        .cornerRadius(13.0)
                        
                        
                        
                        
                        HStack{
                            VStack{
                                HStack{
                                    Spacer()
                                    Image(systemName: "flame.fill")
                                        .padding(.all, -1.0)
                                        .font(.title)
                                        .foregroundColor(Color.white)
                                    
                                    Text("0")
                                        .font(.largeTitle)
                                        .foregroundColor(Color.white)
                                        .padding([.top, .bottom, .trailing], 20.0)
                                        .monospaced()
                                    Spacer()
                                    
                                }
                                .padding(0.0)
                                .background((Color(UIColor(red: 0.9373, green: 0.5294, blue: 0, alpha: 1.0))))
                                .border(/*@START_MENU_TOKEN@*/Color.orange/*@END_MENU_TOKEN@*/, width: 0)
                                .cornerRadius(13.0)
                                
                                Text("Current Streak")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(UIColor(red: 0.9373, green: 0.5294, blue: 0, alpha: 1.0)))
                                
                            }
                            
                            Spacer()
                            
                            VStack{
                                HStack{
                                    Spacer()
                                    Text("0")
                                        .font(.largeTitle)
                                        .foregroundColor(Color.white)
                                        .padding(20.0)
                                        .monospaced()
                                    Spacer()
                                    
                                }
                                .background(Color.indigo)
                                .border(Color.indigo, width: 0)
                                .cornerRadius(13.0)
                                
                                Text("Remaining Today")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.indigo)
                                
                            }
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                    //
                    
                    HStack{
                        Text("My Habits")
                            .font(.title)
                            .padding(5.0)
                        Spacer()
                        NavigationLink(destination: HabitCreateView()){
                            HStack{
                                Image(systemName: "plus")
                                Text("New")
                            }
                            .padding(10.0)
                            
                        }
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(13.0)
                        
                    }
                    
                    
                    ForEach (basicHabit) {item in
                        
                        let currentFreqString = formattedFrequencyString(days: item.days, hrs: item.timeHours, mins: item.timeMins)
                        
                        NavigationLink(destination: HabitBasicView(habitId: item.id, habitIcon: item.icon, habitName: item.name, freqString: currentFreqString)){
                            HStack {
                                VStack(alignment: .leading){
                                    HStack{
                                        Text(item.icon)
                                            .font(.largeTitle)
                                        
                                        VStack(alignment: .leading) {
                                            Text(item.name)
                                                .font(.headline)
                                            Text(currentFreqString)
                                                .font(.caption)
                                            
                                        }
                                        
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.gray)
                                        
                                    }
                                    
                                    if item.progressGoal > 0{
                                        
                                        let habitProgressCurrent = item.progressCurrent
                                        let habitProgressGoal = item.progressGoal
                                        
                                        let progressDecimal = Double(item.progressCurrent) / Double(item.progressGoal)
                                        let progressPercentage =  (Double(item.progressCurrent) / Double(item.progressGoal)) * 100
                                        
                                        let _ = print("progress current is ", String(habitProgressCurrent))
                                        let _ = print("progress goal is ", String(habitProgressGoal))
                                        
                                        let _ = print("CALC progress decimal is ", String(progressDecimal))
                                        let _ = print("CALC progress percentage is ", String(progressPercentage))
                                        
                                        
                                        ProgressView(value: progressDecimal)
                                            .padding(-1.0)
                                        
                                        HStack{
                                            Text(String(progressPercentage) + "%")
                                            Spacer()
                                            Text(String(item.progressCurrent) + " of " + String(item.progressGoal))
                                            
                                        }
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.gray)
                                    }
                                }
                                
                            }
                            .padding(13.0)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(13.0)
                            
                        }
                        
                    }
                    
                    Divider()
                        .padding(.vertical, 20.0)
                    Text("!!Debug!!")
                        .font(.title)
                        .padding(5.0)
                    
                    Button("Clear all notifications") {
                        showNotificationDebug = true
                        handleNotifications()
                        print("all notifications done been cleare :D")

                    }
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(13.0)
                    .foregroundStyle(.red)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(13.0)
                    
                    Button("Print all scheduled notifs") {
                        debugPrintAllNotifs()

                    }
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(13.0)
                    .foregroundStyle(.red)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(13.0)
                    
                    
                    
                }
                
                //                    Button("Clear Habits Database") {
                //                        do {
                //                            try modelContext.delete(model: BasicHabit.self)
                //                        } catch {
                //                            print("Failed to clear habits.")
                //                        }
                //                    }
                //                    .buttonStyle(.bordered)
                //                    .foregroundColor(.red)
                //
                //                    Button("Clear History Database") {
                //                        do {
                //                            try modelContext.delete(model: CompletionHistory.self)
                //                        } catch {
                //                            print("Failed to clear habits.")
                //                        }
                //                    }
                //                    .buttonStyle(.bordered)
                //                    .foregroundColor(.red)
                
            }
            .padding()
            
        }
    }
}

#Preview {
    HomeView()
}
