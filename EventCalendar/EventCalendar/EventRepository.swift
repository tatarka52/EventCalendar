//
//  EventRepository.swift
//  EventCalendar
//
//  Created by Регина on 01.11.2026.
//

import Foundation

class EventRepository {
    private let key = "savedCalendarEvents"

    func getAll() throws -> [CalendarEvent] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        return try JSONDecoder().decode([CalendarEvent].self, from: data)
    }

    func add(_ event: CalendarEvent) throws {
        var events = try getAll()
        events.append(event)
        try save(events)
    }

    func update(_ event: CalendarEvent) throws {
        var events = try getAll()
        guard let index = events.firstIndex(where: { $0.id == event.id }) else {
            return
        }

        events[index] = event
        try save(events)
    }

    func delete(id: UUID) throws {
        var events = try getAll()
        events.removeAll { $0.id == id }
        try save(events)
    }

    private func save(_ events: [CalendarEvent]) throws {
        let data = try JSONEncoder().encode(events)
        UserDefaults.standard.set(data, forKey: key)
    }
}
