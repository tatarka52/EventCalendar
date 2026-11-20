//
//  CalendarEvent.swift
//  EventCalendar
//
//  Created by Регина on 01.11.2026.
//

import Foundation

struct CalendarEvent: Identifiable, Codable {
    let id: UUID
    var title: String
    var startDate: Date
    var endDate: Date

    init(title: String, startDate: Date, endDate: Date) {
        id = UUID()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}
