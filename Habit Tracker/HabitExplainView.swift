//
//  HabitExplainView.swift
//  Habit Tracker
//
//  Created by Finlay Carson Moretti on 26/11/2023.
//

import SwiftUI

struct HabitExplainView: View {
    var body: some View {
        
        ScrollView{
            VStack(alignment: .leading){
                Text("Completion Types")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Text("Habit Tracker lets you create special kinds of habits that are completable with progress towards a goal. ")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 10.0)
                
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(UIColor.systemGray4))
                
                Text("Progress")
                    .font(.title.width(.condensed))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    VStack(alignment: .leading){
                        HStack{
                            Text("📖")
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text("Read Streetcar")
                                    .font(.headline)
                                Text("Daily, 20:00")
                                    .font(.caption)
                                
                            }
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                            
                        }
                        
                        ProgressView(value: 0.78)
                            .padding(-1.0)
                        
                        HStack{
                            Text("78%")
                            Spacer()
                            Text("390 of 500")
                                
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                        
                        
                    }
                    
                    

                }
                .padding(13.0)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(13.0)
                
                Text("This completion type lets you track your progress on a continuous bar. Its unlimited in size and is perfect for tracking small progress through large tasks like pages in a book.")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 10.0)
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(UIColor.systemGray4))
                
                Text("Segmented")
                    .font(.title.width(.condensed))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    VStack(alignment: .leading){
                        HStack{
                            Text("👾")
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text("Computing NEA Chapters")
                                    .font(.headline)
                                Text("Tue, Thu, Sun, 18:00")
                                    .font(.caption)
                                
                            }
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                            
                        }
                        
                        HStack{
                            ProgressView(value: 1)
                                .padding(-1.0)
                            ProgressView(value: 1)
                                .padding(-1.0)
                            ProgressView(value: 0)
                                .padding(-1.0)
                            ProgressView(value: 0)
                                .padding(-1.0)
                            ProgressView(value: 0)
                                .padding(-1.0)
                        }
                            
                        HStack{
                            Text("2/5 complete")
                            Spacer()
                            Text("3 left")
                                
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                        
                        
                    }
                    
                    

                }
                .padding(13.0)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(13.0)
                
                Text("This habit lets you track your progress in segmented portions. You can make up to 50 of them. It's useful for tracking large steps in progress, like chapters in a textbook.")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 10.0)

            }
            
        }
        .padding([.leading, .bottom, .trailing], 30.0)
        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

#Preview {
    HabitExplainView()
}
