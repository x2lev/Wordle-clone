//
//  ContentView.swift
//  Wordle
//
//  Created by Kryvenko, Lev on 3/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var displayLetters = [
        ["", "", "", "", ""],
        ["", "", "", "", ""],
        ["", "", "", "", ""],
        ["", "", "", "", ""],
        ["", "", "", "", ""],
        ["", "", "", "", ""]
    ]
    @State var displayColors: [[Color]] = [
        [.gray, .gray, .gray, .gray, .gray],
        [.gray, .gray, .gray, .gray, .gray],
        [.gray, .gray, .gray, .gray, .gray],
        [.gray, .gray, .gray, .gray, .gray],
        [.gray, .gray, .gray, .gray, .gray],
        [.gray, .gray, .gray, .gray, .gray]
    ]
    @State var keys = "qwertyuiopasdfghjklzxcvbnm"
    @State var input = ""
    @State var guesses = 0
    @State var words: [String] = []
    @State var wordsToGuess: [String] = []
    @State var word = ""
    @State var guessed = false
    @FocusState var textFieldFocused: Bool
    var rectWidth = 70.0
    var body: some View {
        VStack {
            HStack {
                Text("Words Guessed: \("")")
                    .multilineTextAlignment(.leading)
                Spacer()
                Text("Words Missed: \("")")
                    .multilineTextAlignment(.trailing)
            }
            .font(.caption)
            Text("Wordle")
                .font(.title)
                .fontWeight(.black)
            ForEach(0..<6, id: \.self) { row in
                HStack {
                    ForEach(0..<5, id: \.self) { col in
                        Text(displayLetters[row][col])
                            .frame(width:rectWidth,height:rectWidth)
                            .background(displayColors[row][col])
                            .cornerRadius(10)
                            .font(.title2)
                            .animation(.easeIn(duration: 0.5))
                    }
                }
            }
            if !guessed && guesses < 6 {
                HStack {
                    TextField("", text: $input)
                        .frame(height:50)
                        .foregroundColor(.black)
                        .background(.white)
                        .font(.title)
                        .cornerRadius(10)
                        .keyboardType(.alphabet)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .focused($textFieldFocused)
                        .onChange(of: input) { _ in
                            input = input.trimmingCharacters(in: .letters.inverted)
                            if input.count > 0 {
                                input = input.uppercased()
                            }
                            
                            if input.count > 5 {
                                let arr = Array(input)
                                input = ""
                                for i in 0..<5 {
                                    input += String(arr[i])
                                }
                            }
                        }
                        .onSubmit { guess() }
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 3)
                        }
                    Button("Submit") { guess() }
                        .buttonStyle(.bordered)
                        .tint(.gray)
                        .disabled(!words.contains(input))
                }.padding(.horizontal)
            } else {
                Text(guessed
                     ? "You won in \(guesses) \(guesses == 1 ? "guess" : "guesses")!"
                     : "You lost...")
                    .foregroundColor(.white)
                    .font(.title)
                Button("Play Again?") { startGame() }
                    .buttonStyle(.bordered)
                    .tint(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
        .foregroundColor(.white)
        .background(.black)
        .onAppear {
            startGame()
        }
    }
    func startGame() {
        displayLetters = [
            ["", "", "", "", ""],
            ["", "", "", "", ""],
            ["", "", "", "", ""],
            ["", "", "", "", ""],
            ["", "", "", "", ""],
            ["", "", "", "", ""]
        ]
        displayColors = [
            [.gray, .gray, .gray, .gray, .gray],
            [.gray, .gray, .gray, .gray, .gray],
            [.gray, .gray, .gray, .gray, .gray],
            [.gray, .gray, .gray, .gray, .gray],
            [.gray, .gray, .gray, .gray, .gray],
            [.gray, .gray, .gray, .gray, .gray]
        ]
        input = ""
        guesses = 0
        guessed = false
        
        if words == [] {
            do {
                let url = Bundle.main.url(forResource: "sgb-words", withExtension: "txt")!
                let file = try String(contentsOf: url)
                for line in file.split(separator: "\n").shuffled() {
                    words.append(String(line).uppercased())
                    wordsToGuess.append(String(line).uppercased())
                }
            } catch {
                print(error.localizedDescription)
            }
            wordsToGuess.shuffle()
        }
        word = wordsToGuess.popLast() ?? "HELLO"
        print(word)
    }
    func guess() {
        textFieldFocused = false
        if words.contains(input) {
            let arr = Array(input)
            var letters = [true, true, true, true, true]
            
            for (i, l) in word.enumerated() {
                displayLetters[guesses][i] = String(arr[i])
                if arr[i] == l {
                    displayColors[guesses][i] = .green
                    letters[i] = false
                }
            }
            for l in word {
                var i = Array(word).firstIndex(of: l) ?? -1
                var si = word.firstIndex(of: l)!
                while i != -1 && !letters[i] {
                    
                }
            }
            
            if word == input {
                guessed = true
                print("guessed!")
            }
            guesses += 1
            input = ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

