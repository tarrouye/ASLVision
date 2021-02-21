//
//  AlphabetEntryQuizView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

struct AlphabetEntryQuizView: View {
    @ObservedObject var model: QuizTakingViewModel
    
    @StateObject var privModel = AlphabetEntryQuizViewModel()
    
    var entry : AlphabetEntry {
        return ALPHABET[model.currentAlphabetIndex]
    }
    
    func triggerNextStage() {
        if (privModel.state == .ready) {
            privModel.startWithAid()
        } else if (privModel.state == .matchedOne) {
            privModel.startNoAid()
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                PreviewHolder(shouldTakePic: $privModel.shouldCapture)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .onTapGesture {
                triggerNextStage()
            }
            
            VStack {
                HStack(spacing: 0) {
                    Text("CHAR_LABEL")
                        .font(.title)
                        .fontWeight(.regular)
                    
                    Text("\(entry.char.uppercased())")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(5)
                .padding(.horizontal, 10)
                .background(BackgroundBlurView().cornerRadius(50))
                .padding()
                
                if (privModel.state == .withAid || privModel.state == .noAid) {
                    Text("TIME_LABEL \(privModel.currentTimer ?? "----")")
                        .padding(5)
                        .padding(.horizontal, 10)
                        .background(BackgroundBlurView().cornerRadius(50))
                }
            
                Spacer()
                
                if (privModel.state == .ready) {
                    Text("START_AIDED_MATCHING_LABEL")
                        .font(.headline)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .padding(.horizontal, 10)
                        .background(BackgroundBlurView().cornerRadius(25))
                        .frame(width: 300)
                        .onTapGesture {
                            triggerNextStage()
                        }
                } else if (privModel.state == .withAid) {
                    Text("MATCH_THIS_LABEL")
                        .font(.title2)
                        .padding(5)
                        .padding(.horizontal, 5)
                        .background(BackgroundBlurView().cornerRadius(50))
                    if(privModel.imgTest != nil){
                        Image(uiImage: privModel.imgTest)
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(x: -1, y: 1)
                            .frame(width: 300)
                            //.background(Color.blue)
                            .opacity(0.75)
                    }
                    
                    Image("\(entry.char.uppercased())_test")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(x: -1, y: 1)
                        .frame(width: 300)
                        //.background(Color.blue)
                        .opacity(0.75)
                } else if (privModel.state == .matchedOne) {
                    Text("START_AIDLESS_MATCHING_LABEL")
                        .font(.headline)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .padding(.horizontal, 10)
                        .background(BackgroundBlurView().cornerRadius(25))
                        .frame(width: 300)
                        .onTapGesture {
                            triggerNextStage()
                        }
                } else if (privModel.state == .finished) {
                    VStack {
                        Text("RESULTS_LABEL")
                            .font(.headline)
                            .padding(10)
                        
                        HStack(spacing: 0) {
                            Text("WITH_AID_LABEL")
                                .font(.headline)
                                .padding(10)
                            
                            Text(":")
                                .font(.headline)
                                
                            Spacer()
                            
                            Text(privModel.timeToString(privModel.withAidResult))
                                .font(.headline)
                                .padding(10)
                        }
                        .padding(.horizontal, 20)
                        HStack(spacing: 0) {
                            Text("WITHOUT_AID_LABEL")
                                .font(.headline)
                                .padding(10)
                            
                            Text(":")
                                .font(.headline)

                            Spacer()
                            
                            
                            Text(privModel.timeToString(privModel.noAidResult))
                                .font(.headline)
                                .padding(10)
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: {
                            model.logResults(entry, privModel.withAidResult!, privModel.noAidResult!)
                            model.next()
                            privModel.reset(model.currentAlphabetIndex)
                        }) {
                            Text("NEXT_ITEM_LABEL")
                                .font(.headline)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue.clipShape(RoundedRectangle(cornerRadius: 50)))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                    }
                    .background(BackgroundBlurView().cornerRadius(25))
                    .frame(width: 300)
                }
            
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .onAppear(){
            self.privModel.setIndex(model.currentAlphabetIndex)
        }
    }
}
