//
//  CancderVC.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 04/12/2024.
//

import SwiftUI

import SwiftUI


    

struct CalendarRangePicker: View {
    @State private var selectedStartDate: Date? = nil
    @State private var selectedEndDate: Date? = nil
    @State private var currentMonth: Date = Date()
    var is_chose_one_date = false
    let weekdays = ["Sat","Sun", "Mon", "Tue", "Wed", "Thu", "Fri"]
    let calendar = Calendar.current

    var body: some View {
        VStack {
               // Month Header
               HStack {
                   Button(action: {
                       
                       currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
                   }) {
                      
                       Image(systemName: "chevron.left")
                       Spacer()
                   }

                   Text(monthYearFormatter.string(from: currentMonth))
                       .font(.headline)

                   Button(action: {
                       currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
                   }) {
                       Spacer()
                       Image(systemName: "chevron.right")
                   }
               }
               .padding()

               // Weekday Headers
               HStack {
                   ForEach(weekdays, id: \.self) { weekday in
                       Text(weekday)
                           .fontWeight(.bold)
                           .frame(maxWidth: .infinity)
                   }
               }
               .padding(.horizontal)

               // Calendar Grid
               let days = generateDays(for: currentMonth)
               LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                   ForEach(days, id: \.self) { date in
                       DayView(date: date, selectedStartDate: $selectedStartDate, selectedEndDate: $selectedEndDate)
                           .onTapGesture {
                               selectDate(date)
                           }
                   }
               }
               .padding()

               // Display Selected Date
               if let selectedDate = selectedStartDate {
                   Text("Selected Date: \(dateFormatter.string(from: selectedDate))")
                       .padding()
               }
           }
    }

    func selectDate(_ date: Date) {
        if is_chose_one_date {
            selectedStartDate = date
        }else {
            if let start = selectedStartDate {
                if selectedEndDate == nil && date >= start {
                    selectedEndDate = date
                } else {
                    selectedStartDate = date
                    selectedEndDate = nil
                }
            } else {
                selectedStartDate = date
            }
        }
      
    }

    func generateDays(for month: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }

        var days: [Date] = []
        var currentDate = firstWeek.start

        while currentDate < monthInterval.end {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return days
    }

    private let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

struct DayView: View {
    let date: Date
    @Binding var selectedStartDate: Date?
    @Binding var selectedEndDate: Date?

    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .font(.headline)
            .foregroundColor((determineBackgroundColor(for: date) == Color.CSky || determineBackgroundColor(for: date) == Color.CSky.opacity(0.5)) ? Color.white : Color.black )
            .frame(maxWidth: 30, maxHeight: 30)
           .padding(10)
            .background(determineBackgroundColor(for: date))
            .cornerRadius(30)
        
        
    }

    private func determineBackgroundColor(for date: Date) -> Color {
        if let startDate = selectedStartDate, let endDate = selectedEndDate {
            if date >= startDate && date <= endDate {
                return Color.CSky.opacity(0.5)
            }
        } else if date == selectedStartDate {
            return Color.CSky
        }
        return Color.MainColor
    }
}

struct CalendarRangePicker_Previews: PreviewProvider {
    static var previews: some View {
        CalendarRangePicker()
    }
}
