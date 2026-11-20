//
//  ContentView.swift
//  EventCalendar
//
//  Created by Регина on 01.11.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CalendarScreen()
            .environment(\.locale, Locale(identifier: "ru_RU"))
    }
}

#Preview {
    ContentView()
}
