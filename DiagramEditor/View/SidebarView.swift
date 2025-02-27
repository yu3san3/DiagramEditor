//
//  SidebarView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/03.
//

import OuDiaKit
import SwiftUI

struct SidebarView: View {
    enum ViewStatus: Hashable {
        case none
        case station
        case trainType
        case downTimetable(trains: [Train])
        case upTimetable(trains: [Train])
        case diagram(timetable: Timetable)
    }

    @EnvironmentObject var document: DiagramEditorDocument

    @Binding var viewStatus: ViewStatus

    var body: some View {
        List(selection: $viewStatus) {
            DisclosureGroup("Route") {
                NavigationLink(value: ViewStatus.station) {
                    Text("Station")
                }

                NavigationLink(value: ViewStatus.trainType) {
                    Text("TrainType")
                }

                DisclosureGroup("Dia") {
                    ForEach(document.route.timetables) { timetable in
                        DisclosureGroup(timetable.title) {
                            NavigationLink(
                                value: ViewStatus.downTimetable(trains: timetable.down.trains)
                            ) {
                                Text("DownTimetable")
                            }

                            NavigationLink(
                                value: ViewStatus.upTimetable(trains: timetable.up.trains)
                            ) {
                                Text("UpTimetable")
                            }

                            NavigationLink(
                                value: ViewStatus.diagram(timetable: timetable)
                            ) {
                                Text("Diagram")
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
    }
}

#Preview {
    SidebarView(viewStatus: .constant(.none))
}
