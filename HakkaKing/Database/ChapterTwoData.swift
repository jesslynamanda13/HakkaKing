import Foundation
import SwiftData

public func seedChapter2(context:ModelContext){
    var chapter2: Chapter = Chapter(orderIndex: 2, chapterName: "Mama, kamu masak apa?", chapterDescription: "Obrolan singkat dengan orang tua saat jam makan.", coverImage: "c2cover")

    let sentence1 = Sentence(orderIndex:1, pinyin: "Mak nyi cu mai?", hanzi: "妈妈，你在做什么菜？", translation: "Mama, kamu masak apa?", audioURL: "c2s1.m4a", character: "Anak")
    let sentence2 = Sentence(orderIndex:2, pinyin: "Cu choi.", hanzi: "烹饪蔬菜。", translation: "Masak sayur.", audioURL: "c2s2.m4a", character: "Mama")
    let sentence3 = Sentence(orderIndex: 3, pinyin: "An ho shit, nga tu si ki.", hanzi: "太好了，我饿了。", translation: "Enaknya, saya lapar.", audioURL: "c2s3.m4a", character: "Anak")
    let sentence4 = Sentence(orderIndex:4, pinyin: "Shit liau.", hanzi: "请吃饭。", translation: "Silakan makan.", audioURL: "c2s4.m4a", character: "Mama")
    
    // sentence 1
    let mak = Word(pinyin: "mak", translation: "mama", audioURL: "mak.m4a")
    let nyi = Word(pinyin: "nyi", translation: "kamu", audioURL: "nyi.m4a")
    let cu = Word(pinyin: "cu", translation: "masak", audioURL: "cu.m4a")
    let mai = Word(pinyin: "mai", translation: "apa", audioURL: "mai.m4a")
    
    let sw1c2s1 = SentenceWord(sentenceID: sentence1.id, wordID: mak.id, position: 0)
    let sw2c2s1 = SentenceWord(sentenceID: sentence1.id, wordID: nyi.id, position: 1)
    let sw3c2s1 = SentenceWord(sentenceID: sentence1.id, wordID: cu.id, position: 2)
    let sw4c2s1 = SentenceWord(sentenceID: sentence1.id, wordID: mai.id, position: 3)
    
    // sentence 2
    let choi = Word(pinyin: "choi", translation: "sayur", audioURL: "choi.m4a")
    
    let sw1c2s2 = SentenceWord(sentenceID: sentence2.id, wordID: cu.id, position: 1)
    let sw2c2s2 = SentenceWord(sentenceID: sentence2.id, wordID: choi.id, position: 1)
    
    // sentence 3
    let an = Word(pinyin: "an", translation: "sekali", audioURL: "an.m4a")
    let hoShit = Word(pinyin: "ho shit", translation: "enak", audioURL: "hoshit.m4a")
    let nga = Word(pinyin: "nga", translation: "saya", audioURL: "nga-saya.m4a")
    let tushi = Word(pinyin: "tu si", translation: "perut", audioURL: "tushi.m4a")
    let ki = Word(pinyin: "ki", translation: "lapar", audioURL: "ki.m4a")
    
    let sw1c2s3 = SentenceWord(sentenceID: sentence3.id, wordID: an.id, position: 0)
    let sw2c2s3 = SentenceWord(sentenceID: sentence3.id, wordID: hoShit.id, position: 1)
    let sw3c2s3 = SentenceWord(sentenceID: sentence3.id, wordID: nga.id, position: 2)
    let sw4c2s3 = SentenceWord(sentenceID: sentence3.id, wordID: tushi.id, position: 3)
    let sw5c2s3 = SentenceWord(sentenceID: sentence3.id, wordID: ki.id, position: 4)
    
    // sentence 4
    let shit = Word(pinyin: "shit", translation: "makan", audioURL: "shit.m4a")
    let liau = Word(pinyin: "liau", translation: "silakan", audioURL: "liau.m4a")
    
    let sw1c2s4 = SentenceWord(sentenceID: sentence4.id, wordID: shit.id, position: 0)
    let sw2c2s4 = SentenceWord(sentenceID: sentence4.id, wordID: liau.id, position: 1)
    
    // insert database
    context.insert(sentence1)
    context.insert(sentence2)
    context.insert(sentence3)
    context.insert(sentence4)
    
    // Sentence-Word 1
    context.insert(mak)
    context.insert(nyi)
    context.insert(cu)
    context.insert(mai)
    
    context.insert(sw1c2s1)
    context.insert(sw2c2s1)
    context.insert(sw3c2s1)
    context.insert(sw4c2s1)
    
    // Sentence-Word 2
    context.insert(choi)
    context.insert(sw1c2s2)
    context.insert(sw2c2s2)
    
    // Sentence-Word 3
    context.insert(an)
    context.insert(hoShit)
    context.insert(nga)
    context.insert(tushi)
    context.insert(ki)
    context.insert(sw1c2s3)
    context.insert(sw2c2s3)
    context.insert(sw3c2s3)
    context.insert(sw4c2s3)
    context.insert(sw5c2s3)
    
    // Sentence-Word 4
    context.insert(shit)
    context.insert(liau)
    context.insert(sw1c2s4)
    context.insert(sw2c2s4)
    
    chapter2.sentences = [sentence1.id, sentence2.id, sentence3.id, sentence4.id]
    context.insert(chapter2)
}
