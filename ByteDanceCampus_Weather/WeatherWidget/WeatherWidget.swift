//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by TH on 8/26/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
            VStack(alignment: .leading) {
                Group {
                    HStack {
                        Image(uiImage: UIImage(named: "03-s")!)
                            .resizable()
                            .frame(width: 37, height: 22, alignment: .leading)
                            .offset(x: -10)
                            .padding(.top, 5)
                        Text("晴")
                            .padding(.top, 5)
                            .padding(.leading, -8)
                            .foregroundColor(.yellow)
                        Spacer()
                    }
                    HStack {
                        Image("HighTemp")
                            .resizable()
                            .frame(width: 15, height: 19)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing, 3)
                        Text("38°")
                            .foregroundColor(.red)
                        Image("LowTemp")
                            .resizable()
                            .frame(width: 15, height: 19)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing, 3)
                        Text("20°")
                            .foregroundColor(.green)
                    }
                    HStack {
                        Text("重庆市")
                            .foregroundColor(.black)
                    }
                }.foregroundColor(.white)
            } .padding(.leading, 20)
            .background {
                Image("BlueSky")
            }
    }
}


@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
