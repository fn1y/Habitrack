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
//    var habitId: String
//    var habitIcon: String
//    var habitName: String
//    var freqString: String
//    var progressCurrent: Int
//    var progressGoal: Int
    var currentHabit: BasicHabit
    
    //Pinging todays date for the completion and completion check operations. We need todays date to see if the habit is already listed as done for today
    let today = getDate()
    
    @State private var presentDelConfirm: Bool = false
    @State private var deletionConfirmed: Bool = false
    @State private var showUncompletableAlert: Bool = false
    @State private var showProgressEditAlert: Bool = false
    @State private var progressEditValue = ""
    
    //I'm getting the current presentationmode as a variable which I can then change, so I can dismiss this view when the delete action is completed
    @Environment(\.presentationMode) var presentationMode
    
    //Setting up link "context" to the persistent storage. A bridge between this view and the actual database.
    @Environment(\.modelContext) private var context
    
    //Query the databases and get all entries from them in the form of arrays. Not very efficient, but required for an equally unefficient function I made which I need to update
    @Query private var habit: [BasicHabit]
    @Query private var history: [CompletionHistory]
    
    func deleteHabit(){
        
        deleteNotifs(identifier:currentHabit.id)
        context.delete(currentHabit)
        
    }
    
    func completeHabit(){
        //this is REALLY SILLY AND INEFFICIENT! NEED TO FIND A BETTER WAY TO DO THIS!! UNNECESSARILY CHECKING THROUGH ENTIRE DATABASES AS ARRAYS IS NOT GOOD!!!
        
        //Why did I print out the entire databases here??
        print(habit)
        print(history)
        
        var saveArray = [String]()
        
        saveArray.append(currentHabit.id)
        
        print("Habit id IS", currentHabit.id)
        
        
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
                    if i == currentHabit.id{
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
        
        if currentHabit.days.contains(dayOfWeek){
            returnBool = true
        }
        
        return returnBool
    }
    
    func updateHabitProgress(updateValue: String){
        
        if let newValue = Int(progressEditValue) {
            currentHabit.progressCurrent = newValue
                        }
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
                //If habit is due today, and is a progress habit, but HAS NOT been completed, let the user mark as complete.
                else if habitIsToday() && currentHabit.progressGoal > 0 {
                    
                    Button("Log Progress & Mark as Done") {
                        showProgressEditAlert = true
                    }
                    .tint(.green)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .alert("What's your current progress now?", isPresented: $showProgressEditAlert) {
                        TextField("New current progress", text: $progressEditValue)
                            .keyboardType(.numberPad)  // Set keyboard type to number pad
                            .textInputAutocapitalization(.never)
                        Button("OK") {
                                updateHabitProgress(updateValue: progressEditValue)
                                completeHabit()
                            }
                        Button("Cancel", role: .cancel) { }
                    }
                }
                //If habit is due today, and is NOT a progress habit, and HAS NOT been completed, let the user mark as complete.
                else if habitIsToday() {
                    
                    Button("Mark as Done") {
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
                                Text(currentHabit.icon)
                                    .foregroundColor(.black)
                                    .font(.largeTitle)
                            }
                            
                            
                            Text(currentHabit.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(String(formattedFrequencyString(days:currentHabit.days, hrs:currentHabit.timeHours, mins:currentHabit.timeMins)))
                                .font(.title3)
                            
                            if currentHabit.progressGoal > 0{
                                
                                let habitProgressCurrent = currentHabit.progressCurrent
                                let habitProgressGoal = currentHabit.progressGoal
                                
                                let progressDecimal = Double(currentHabit.progressCurrent) / Double(currentHabit.progressGoal)
                                let progressPercentage =  (Double(currentHabit.progressCurrent) / Double(currentHabit.progressGoal)) * 100
                                
                                
                                VStack{
                                    ProgressView(value: progressDecimal)
                                        .padding(-1.0)
                                    
                                    
                                    HStack{
                                        Text(String(progressPercentage) + "%")
                                        Spacer()
                                        Text(String(currentHabit.progressCurrent) + " of " + String(currentHabit.progressGoal))
                                        
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
                    
                    Text(String(currentHabit.id))
                        .monospaced()
                    
                    if currentHabit.progressGoal > 0{
                        Text(String("Progress or Segmented"))
                            .monospaced()
                    }
                    else{
                        Text(String("Basic"))
                            .monospaced()
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
        HabitBasicView(currentHabit: BasicHabit(icon: "👻", name: "Read Book", days: [1,2,3,4,5,6,7], timeHours: 10, timeMins: 30, progressCurrent: 30, progressGoal: 100))
    }
}

