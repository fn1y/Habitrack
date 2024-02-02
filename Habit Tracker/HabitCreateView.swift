//
//  HabitCreateView.swift
//  Habit Tracker
//
//  Created by Finlay Carson Moretti on 14/08/2023.
//

import SwiftUI
import SwiftData
import Foundation
import MCEmojiPicker

struct HabitCreateView: View {
    
    func createBasic() {
        //Create the item
        
        var dayArray = [Int]()
        
        let selectedDays = [selectedSun, selectedMon, selectedTue, selectedWed, selectedThu, selectedFri, selectedSat]
        
        for (count, isSelected) in selectedDays.enumerated(){
            if isSelected {
                        // The index starts from 0, so add 1 to get the corresponding day
                        dayArray.append(count + 1)
                    }
        }
        
        if habitType == 1{
            let item = BasicHabit(icon: selectedEmoji, name: habitName, days: dayArray, timeHours: selectedHour, timeMins: selectedMinute, progressCurrent: -1, progressGoal: -1)
            
            //Add it to the context
            context.insert(item)
        }
        else if habitType == 2 || habitType == 3{
            let item = BasicHabit(icon: selectedEmoji, name: habitName, days: dayArray, timeHours: selectedHour, timeMins: selectedMinute, progressCurrent: progressCurrentValue, progressGoal: progressGoalValue)
            
            //Add it to the context
            context.insert(item)
        }
        
        scheduleNotifs(habitId:"nul",hour:selectedHour,minute:selectedMinute,days:dayArray,bodyText: habitName,bodyIcon:selectedEmoji)
        
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    //Setting up link "context" to the persistent storage. A bridge between this view and the actual database.
    @Environment(\.modelContext) private var context
    
    //Query the database and get entry from it in the form of an array
    @Query private var habit: [HabitTest]
    
    @State private var activeHabitUUID = UserDefaults.standard.string(forKey: "ActiveUUID")
    
    enum Day: String, CaseIterable {
        case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    }
    
    @State private var selectedEmoji = "🤣"
    @State private var isPresented = false
    
    @State private var habitName = ""
    @State private var habitType = 1
    @State private var progressCurrentValue = 0
    @State private var progressGoalValue = 1
    
    @State private var habitBuildType = 1
    
    @State private var selectedMon = false
    @State private var selectedTue = false
    @State private var selectedWed = false
    @State private var selectedThu = false
    @State private var selectedFri = false
    @State private var selectedSat = false
    @State private var selectedSun = false
    
    
    //Despite only showing the time the date picker is still a date picker and needs to be initialised as such.
    @State private var selectedTime = Date()
    
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    
    @State private var animateCount = Int(0)
    @State private var animateTick = false

    
    var body: some View {
        
        ZStack{
            //Sticks the button to the bottom on a layer above the main content, so it'll be at the bottom of the screen no matter what, and the habit creator is still visible and scrollable underneath
            VStack{
                Spacer()
                Button(action: {
                    animateCount = animateCount + 1
                    createBasic()
                    
                    //Set the presentation mode to dismiss to go back to home page wahoo
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
                            .symbolEffect(.bounce.down.byLayer, value:animateCount)
                
                        Text("Create Habit")
                    }
                }
                .tint(.accentColor)
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
            }
            ScrollView{
                
                VStack(alignment: .leading){
                    
                    
                    
                    
                    Text("New Habit")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical, 10.0)
                    
                    
//                    Text("Do you want to build a new habit, or abstain from a current one?")
//                    
//                    Picker(selection: $habitBuildType, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
//                        Text("Build").tag(1)
//                        Text("Abstain").tag(2)
//                    }
                    .pickerStyle(.segmented)
                    
                    Text("Emoji Icon")
                        .font(.headline)
                    
                    HStack{
                        Button(selectedEmoji) {
                            isPresented.toggle()
                        }.emojiPicker(
                            isPresented: $isPresented,
                            selectedEmoji: $selectedEmoji
                        )
                    }
                    .cornerRadius(30.0)
                    .font(.title)
                    .padding(5.0)
                    .overlay( // apply a rounded border
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                    )
                    Text("Habit Name")
                        .font(.headline)
                    
                    TextField("e.g. Walk the Dog", text: $habitName)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Habit Frequency")
                        .font(.headline)
                    
                    HStack {
                        Button("M") {
                            selectedMon.toggle()
                        }
                        .buttonStyle(DayButton(isSelected: selectedMon))
                        .cornerRadius(/*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                        
                        Button("T") {
                            selectedTue.toggle()
                        }
                        .buttonStyle(DayButton(isSelected: selectedTue))
                        .cornerRadius(/*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                        
                        Button("W") {
                            selectedWed.toggle()
                        }
                        .buttonStyle(DayButton(isSelected: selectedWed))
                        .cornerRadius(/*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                        
                        Button("T") {
                            selectedThu.toggle()
                        }
                        .buttonStyle(DayButton(isSelected: selectedThu))
                        .cornerRadius(/*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                        
                        Button("F") {
                            selectedFri.toggle()
                        }
                        .buttonStyle(DayButton(isSelected: selectedFri))
                        .cornerRadius(/*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                        
                        Button("S") {
                            selectedSat.toggle()
                        }
                        .buttonStyle(DayButton(isSelected: selectedSat))
                        .cornerRadius(/*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                        
                        Button("S") {
                            selectedSun.toggle()
                        }
                        .buttonStyle(DayButton(isSelected: selectedSun))
                        .cornerRadius(/*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                    }
                    .frame(maxWidth: .infinity)
                    
                    DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .onChange(of: selectedTime) {
                            updateHourAndMinute()
                        }
                    
                    HStack{
                        Text("Habit Type")
                            .font(.headline)
                        NavigationLink(destination: HabitExplainView()) {
                            Image(systemName: "questionmark.circle")
                        }
                    }
                    
                    Picker(selection: $habitType, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                        Text("General").tag(1)
                        Text("Progress").tag(2)
                        Text("Segmented").tag(3)
                    }
                    
                    
                    if habitType == 2{
                        HStack{
                            
                            TextField("Start Value", value: $progressCurrentValue, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)

                            
                            TextField("End Value", value: $progressGoalValue, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)

                            
                        }
                    }
                    
                    
                }
                
            }
            .padding([.leading, .bottom, .trailing], 20.0)
            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, alignment: .leading) // Stick to the left side
            
        }
        
        
    }
    
    private func updateHourAndMinute() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: selectedTime)
        
        if let hour = components.hour, let minute = components.minute {
            selectedHour = hour
            selectedMinute = minute
        }
        
    }
    
    struct DayButton: ButtonStyle {
        var isSelected: Bool

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(10.0)
                .background(isSelected ? Color.indigo : Color(UIColor.systemGray4))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
}

#Preview {
    HabitCreateView()
}


