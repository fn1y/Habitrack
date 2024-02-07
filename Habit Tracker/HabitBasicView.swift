//
//  HabitBasicView.swift
//  Habit Tracker
//
//  Created by Finlay Carson Moretti on 13/08/2023.
//

import SwiftUI
import SwiftData

struct HabitBasicView: View {
    
    //Setting up basic habit info, these will be passed in from HomeView when navigated to
    var habitId: String
    var habitIcon: String
    var habitName: String
    var freqString: String
    var progressCurrent: Int
    var progressGoal: Int
    
    //Pinging todays date for the completion and completion check operations. We need todays date to see if the habit is already listed as done for today
    let today = getDate()
    
    @State private var presentDelConfirm: Bool = false
    @State private var deletionConfirmed: Bool = false
    @State private var showUncompletableAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    //Setting up link "context" to the persistent storage. A bridge between this view and the actual database.
    @Environment(\.modelContext) private var context
    
    //Query the database and get entry from it in the form of an array
    @Query private var habit: [BasicHabit]
    @Query private var history: [CompletionHistory]
    
    func deleteHabit(){
        
        deleteNotifs(identifier:habitId)
        
        // Create a predicate to search for the current habit item in the database via its UUID
        let predicate = #Predicate<BasicHabit> { habit in
            habit.id == habitId
        }
        
        //Try to delete it. Must handle this otherwise app crashes due to no result so printing an error. UUID should exist though as we wouldn't already be on this SwiftUI view without it.
        do {
            try context.delete(model: BasicHabit.self, where: predicate)
        } catch {
            print("Habit ID wasn't found (for some reason)")
        }
        
        deleteNotifs(identifier:habitId)
        
    }
    
    func completeHabit(){
        
        print(habit)
        print(history)
        
        var saveArray = [String]()
        
        saveArray.append(habitId)
        
        print("Habit id IS", habitId)
        
        
        for day in history{
            if day.date == today{
                print(day)
            }
        }
        
        let item = CompletionHistory(inputDate: today, inputHabits: saveArray, inputCompletion: -1)
        
        print ("now going to save item: ", item)
        
        //Add it to the context
        context.insert(item)
        
        
    }
    
    func habitIsCompleted() -> Bool{
        var returnBool = false
        
        for day in history{
            print("Comparing against array at date ", day.date)
            if day.date == today{
                print("Date matched")
                for i in day.habits{
                    if i == habitId{
                        returnBool = true
                    }
                }
            }
        }
        
        return returnBool
        
    }
    
    func habitIsToday() -> Bool{
        var returnBool = false
        
        let dayOfWeek = getDayOfWeek()
        
        for i in habit{
            if i.id == habitId && i.days.contains(dayOfWeek){
                returnBool = true
            }
        }
        
        return returnBool
    }
    
    func updateHabitProgress(updateValue: Int){
        // Get the current BasicHabit object based on passed habitId
        
    }
    
    var body: some View {
        
        ZStack{
            //Sticks the button to the bottom on a layer above the main content, so it'll be at the bottom of the screen no matter what, and the main habit content is still visible and scrollable underneath
            VStack{
                Spacer()
                
                //If habit is due today, and has already been completed, show the user a "Completed" button.
                if habitIsToday() && habitIsCompleted(){
                    
                    
                    Button("Completed!") {
                        print("button done been pressed")
                        showUncompletableAlert = true
                    }
                    .tint(.gray)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .alert(isPresented: $showUncompletableAlert) {
                        Alert(title: Text("Already Completed"), message: Text("You've already marked this habit as complete! Keep up the good work."), dismissButton: .default(Text("Got it"))) }
                }
                //If habit is due today but HAS NOT been completed, let the user mark as complete.
                else if habitIsToday(){
                    
                    Button("Mark as Complete") {
                        completeHabit()
                    }
                    .tint(.green)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                }
                //If habit is neither, show user a "Not due" button
                else{
                    Button("Not due today") {
                        print("button done been pressed")
                        showUncompletableAlert = true
                    }
                    .tint(.gray)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .alert(isPresented: $showUncompletableAlert) {
                        Alert(title: Text("Not due today"), message: Text("You can't mark this habit as complete as it's not scheduled for any time today."), dismissButton: .default(Text("Got it")))}
                }
                
                
            }
            ScrollView{
                
                VStack(alignment: .center){
                    
                    VStack(alignment: .center){
                        
                        VStack(alignment: .center){
                            
                            ZStack {
                                Circle()
                                    .stroke(Color.black, lineWidth: 0)
                                    .fill(Color(UIColor.systemGray6))
                                    .frame(width: 100, height: 100)
                                Circle()
                                    .stroke(Color(UIColor.systemGray6), lineWidth: 5)
                                    .frame(width: 120, height: 120)
                                    .opacity(0.8)
                                Circle()
                                    .stroke(Color(UIColor.systemGray6), lineWidth: 5)
                                    .frame(width: 145, height: 145)
                                    .opacity(0.5)
                                Circle()
                                    .stroke(Color(UIColor.systemGray6), lineWidth: 5)
                                    .frame(width: 170, height: 170)
                                    .opacity(0.25)
                                Text(habitIcon)
                                    .foregroundColor(.black)
                                    .font(.largeTitle)
                            }
                            
                            
                            Text(habitName)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(freqString)
                                .font(.title3)
                            
                            if progressGoal > 0{
                                
                                let habitProgressCurrent = progressCurrent
                                let habitProgressGoal = progressGoal
                                
                                let progressDecimal = Double(progressCurrent) / Double(progressGoal)
                                let progressPercentage =  (Double(progressCurrent) / Double(progressGoal)) * 100
                                
                                //                                        let _ = print("progress current is ", String(habitProgressCurrent))
                                //                                        let _ = print("progress goal is ", String(habitProgressGoal))
                                //
                                //                                        let _ = print("CALC progress decimal is ", String(progressDecimal))
                                //                                        let _ = print("CALC progress percentage is ", String(progressPercentage))
                                
                                
                                VStack{
                                    ProgressView(value: progressDecimal)
                                        .padding(-1.0)
                                    
                                    
                                    HStack{
                                        Text(String(progressPercentage) + "%")
                                        Spacer()
                                        Text(String(progressCurrent) + " of " + String(progressGoal))
                                        
                                    }
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.gray)
                                }
                                .frame(width: 300)
                            }
                        }
                        
                        Spacer()
                        
                        
                        Button(action: {
                                        presentDelConfirm = true
                                    }) {
                                        Image(systemName: "trash.circle.fill")
                                            .font(.title)
                                    }
                        .accentColor(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
                        .alert("Delete this habit?", isPresented: $presentDelConfirm){
                            Button("Cancel", role: .cancel){}
                            Button("Delete", role: .destructive){
                                deleteHabit()
                                presentationMode.wrappedValue.dismiss()
                            }
                            
                        }
                        
                    }
                    
                    Divider()
                        .padding(.vertical, 10.0)
                    
                    Text(String(habitId))
                        .monospaced()
                    
                    if progressGoal > 0{
                        Text(String("Type: Progress"))
                    }
                    else{
                        Text(String("Type: Basic"))
                    }
                    
                    
                    
                }
                
            }
            .padding([.leading, .bottom, .trailing], 20.0)
            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, alignment: .leading) // Stick to the left side
        }
        
    }
}

struct HabitBasicView_Previews: PreviewProvider {
    static var previews: some View {
        HabitBasicView(habitId: "", habitIcon: "👾", habitName: "Habit Name", freqString: "Daily at 20:00", progressCurrent: 15, progressGoal: 40)
    }
}

