//
//  SidebarView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/03.
//

import OuDiaKit
import SwiftUI

struct SidebarView: View {
    enum ViewState: Hashable {
        case none
        case station
        case trainType
        case downTimetable(trains: [Train])
        case upTimetable(trains: [Train])
        case diagram(timetable: Timetable)
    }

    @EnvironmentObject var document: DiagramEditorDocument

    @Binding var viewState: ViewState

    var body: some View {
        List(selection: $viewState) {
            DisclosureGroup("Route") {
                NavigationLink(value: ViewState.station) {
                    Text("Station")
                }

                NavigationLink(value: ViewState.trainType) {
                    Text("TrainType")
                }

                DisclosureGroup("Dia") {
                    ForEach(document.route.timetables) { timetable in
                        DisclosureGroup(timetable.title) {
                            NavigationLink(
                                value: ViewState.downTimetable(trains: timetable.down.trains)
                            ) {
                                Text("DownTimetable")
                            }

                            NavigationLink(
                                value: ViewState.upTimetable(trains: timetable.up.trains)
                            ) {
                                Text("UpTimetable")
                            }

                            NavigationLink(
                                value: ViewState.diagram(timetable: timetable)
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
    SidebarView(viewState: .constant(.none))
}
