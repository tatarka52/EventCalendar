//
//  CalendarScreen.swift
//  EventCalendar
//
//  Created by Регина on 01.11.2026.
//

import SwiftUI

struct CalendarScreen: View {
    @StateObject private var vm = CalendarState()

    @State private var showAdd = false
    @State private var editEvent: CalendarEvent?

    var body: some View {
        NavigationStack {
            List {
                calendarSection
                errorSection
                eventsSection
            }
            .navigationTitle("Календарь")

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAdd = true
                    } label: {
                        Label("Добавить событие", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd, onDismiss: vm.loadEvents) {
                EventEditorView(vm: vm)
            }

            .sheet(item: $editEvent, onDismiss: vm.loadEvents) { event in
                EventEditorView(vm: vm, event: event)
            }
        }
    }

    private var calendarSection: some View {
        Section {
            DatePicker(
                "Выбранная дата",
                selection: $vm.date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
        }
    }

    private var errorSection: some View {
        Group {
            if let error = vm.errorText {
                Text(error)
                    .foregroundStyle(.red)
            }
        }
    }

    private var eventsSection: some View {
        Section(
            vm.date.formatted(date: .complete, time: .omitted)
        ) {
            if vm.dayEvents.isEmpty && vm.errorText == nil {
                Text("На этот день событий нет")
                    .foregroundStyle(.secondary)
            }

            ForEach(vm.dayEvents) { event in
                eventRow(event)
            }
        }
    }

    private func eventRow(_ event: CalendarEvent) -> some View {
        Button {
            editEvent = event
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                Text(event.title)
                    .foregroundStyle(.primary)

                Text(
                    "Начало: \(event.startDate.formatted(date: .numeric, time: .shortened))"
                )

                Text(
                    "Окончание: \(event.endDate.formatted(date: .numeric, time: .shortened))"
                )
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .swipeActions {
            Button(role: .destructive) {
                vm.delete(event)
            } label: {
                Label("Удалить", systemImage: "trash")
            }
        }
    }
}
