//
//  PresetViewModel.swift
//  ToDoList
//
//  Created by Cedric Petilos on 12/27/24.
//

import Foundation

class PresetViewModel: ObservableObject {
    @Published var categories: [String: [PresetItem]] = [
        "#Morning": [
            PresetItem(name: "🛏 Make Bed", description: "Experience a different life by making your bed"),
            PresetItem(name: "🧘‍♂️ Meditate", description: "Start your day with mindfulness and peace"),
            PresetItem(name: "🍳 Eat Healthy Breakfast", description: "Fuel your body with a nutritious meal"),
            PresetItem(name: "🚶‍♂️ Go for a Walk", description: "Start the day with fresh air and movement"),
            PresetItem(name: "📚 Read a Chapter", description: "Expand your knowledge with a daily read"),
            PresetItem(name: "☕ Drink Coffee", description: "Start your day with your favorite cup of coffee"),
            PresetItem(name: "🎧 Listen to Music", description: "Get into the right mood with your favorite tunes"),
            PresetItem(name: "📝 Write in Journal", description: "Reflect on your thoughts and set intentions"),
            PresetItem(name: "🧑‍💻 Check Emails", description: "Stay on top of your communications and tasks"),
            PresetItem(name: "🧖‍♀️ Take a Shower", description: "Start fresh with a rejuvenating shower"),
            PresetItem(name: "📅 Review Calendar", description: "Look ahead and plan your schedule for the day"),
            PresetItem(name: "🌞 Enjoy the Sunlight", description: "Get your daily dose of vitamin D"),
            PresetItem(name: "👕 Dress for Success", description: "Choose an outfit that makes you feel good"),
            PresetItem(name: "💪 Do Morning Stretch", description: "Loosen up your body with a light stretch"),
            PresetItem(name: "🌿 Water Plants", description: "Take care of your plants and feel connected to nature")
        ],
        "#Night": [
            PresetItem(name: "📖 Read Book", description: "Relax before bed with a good book"),
            PresetItem(name: "🗓 Plan Tomorrow", description: "Prepare for the day ahead"),
            PresetItem(name: "🌙 Meditate", description: "End your day with a calm mind and meditation"),
            PresetItem(name: "🎬 Watch a Movie", description: "Unwind by watching your favorite movie"),
            PresetItem(name: "🛁 Take a Bath", description: "Relax your muscles with a soothing bath"),
            PresetItem(name: "📱 Set Phone on Do Not Disturb", description: "Avoid distractions by silencing notifications"),
            PresetItem(name: "🌒 Reflect on Day", description: "Think about what went well today and what can improve"),
            PresetItem(name: "🍵 Drink Herbal Tea", description: "Relax with a warm cup of chamomile or peppermint tea"),
            PresetItem(name: "💤 Set Sleep Schedule", description: "Prepare yourself for a restful sleep"),
            PresetItem(name: "💡 Dim the Lights", description: "Set the mood by dimming the lights in the evening"),
            PresetItem(name: "👗 Change into Pajamas", description: "Get cozy and change into comfortable sleepwear"),
            PresetItem(name: "🔒 Lock the Doors", description: "Ensure your home is safe and secure before bed"),
            PresetItem(name: "📓 Write in Journal", description: "Reflect on the day and note your thoughts"),
            PresetItem(name: "🛋 Relax on Couch", description: "Spend a few minutes unwinding before bed"),
            PresetItem(name: "🧑‍💻 Disconnect from Screen", description: "Give your eyes a rest by turning off screens before bed")
        ],
        "#Daily": [
            PresetItem(name: "💧 Drink Water", description: "Stay hydrated throughout the day"),
            PresetItem(name: "🏋️‍♀️ Exercise", description: "Stay active and healthy"),
            PresetItem(name: "🍽 Eat Balanced Meals", description: "Nourish your body with wholesome meals"),
            PresetItem(name: "🧘‍♂️ Stretch", description: "Loosen up and improve flexibility"),
            PresetItem(name: "📝 Make To-Do List", description: "Stay organized with a clear daily plan"),
            PresetItem(name: "🚶‍♀️ Walk 10,000 Steps", description: "Get moving and reach your step goal"),
            PresetItem(name: "📖 Read a Book", description: "Read a chapter or two to expand your knowledge"),
            PresetItem(name: "💼 Work Productively", description: "Focus on your professional tasks and responsibilities"),
            PresetItem(name: "🧑‍💻 Learn Something New", description: "Dedicate time each day to learning and growth"),
            PresetItem(name: "🎨 Practice a Hobby", description: "Spend time on something creative or relaxing"),
            PresetItem(name: "📅 Review Goals", description: "Check in with your long-term goals and progress"),
            PresetItem(name: "💆‍♀️ Relax", description: "Take a break to recharge your energy"),
            PresetItem(name: "🧹 Clean and Tidy Up", description: "Keep your living space organized and clean"),
            PresetItem(name: "👯‍♀️ Socialize", description: "Make time for social interactions with loved ones"),
            PresetItem(name: "💪 Do Strength Training", description: "Strengthen your muscles with resistance exercises")
        ]
    ]
}

struct PresetItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
}
