//
//  CalendarState.swift
//  EventCalendar
//
//  Created by Регина on 01.11.2026.
//

import Foundation
import Combine

@MainActor
class CalendarState: ObservableObject {
    @Published var date = Date()
    @Published var events: [CalendarEvent] = []
    @Published var errorText: String?

    private let repo = EventRepository()

    init() {
        loadEvents()
    }

    var dayEvents: [CalendarEvent] {
        events.filter { event in
            // Сравнение календарных дней, а не точного времени
            Calendar.current.isDate(event.startDate, inSameDayAs: date)
        }
        .sorted { $0.startDate < $1.startDate }
    }

    func loadEvents() {
        do {
            events = try repo.getAll()
            errorText = nil
        } catch {
            errorText = "Не удалось загрузить события: \(error.localizedDescription)"
        }
    }

    func save(
        oldEvent: CalendarEvent?,
        title: String,
        startDate: Date,
        endDate: Date
    ) -> Bool {
        let text = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else {
            errorText = "Введите название события"
            return false
        }

        guard endDate > startDate else {
            errorText = "Окончание должно быть позже начала"
            return false
        }

        do {
            if var event = oldEvent {
                event.title = text
                event.startDate = startDate
                event.endDate = endDate

                try repo.update(event)
            } else {
                let event = CalendarEvent(
                    title: text,
                    startDate: startDate,
                    endDate: endDate
                )

                try repo.add(event)
            }

            date = startDate
            errorText = nil
            loadEvents()
            return true
        } catch {
            errorText = "Не удалось сохранить событие: \(error.localizedDescription)"
            return false
        }
    }

    func delete(_ event: CalendarEvent) {
        do {
            try repo.delete(id: event.id)
            loadEvents()
        } catch {
            errorText = "Не удалось удалить событие: \(error.localizedDescription)"
        }
    }
}
