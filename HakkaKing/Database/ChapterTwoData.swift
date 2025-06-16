import Foundation
import SwiftData

public func seedChapter2(context:ModelContext){
    let chapter2 = Chapter(orderIndex: 2, chapterName: "Chapter 2", chapterDescription: "Mama, kamu masak apa?")
    context.insert(chapter2)

    let s1 = Sentence(orderIndex:1, pinyin: "Mak nyi cu mai?", hanzi: "妈妈，你在做什么菜？", translation: "Mama, kamu masak apa?", audioURL: "c2s1.m4a")
    let s2 = Sentence(orderIndex:2, pinyin: "Cu choi.", hanzi: "烹饪蔬菜。", translation: "Masak sayur.", audioURL: "c2s2.m4a")
    let s3 = Sentence(orderIndex: 3, pinyin: "An ho shit, nga tu si ki.", hanzi: "太好了，我饿了。", translation: "Enaknya, saya lapar.", audioURL: "c2s3.m4a")
    let s4 = Sentence(orderIndex:4, pinyin: "Shit liau.", hanzi: "请吃饭。", translation: "Silakan makan.", audioURL: "c2s4.m4a")
    let sentences = [s1, s2, s3, s4]
    sentences.forEach { $0.chapter = chapter2 }
    sentences.forEach { context.insert($0) }

    let mak = Word(pinyin: "mak", translation: "mama", audioURL: "mak.m4a"); context.insert(mak)
    let nyi = Word(pinyin: "nyi", translation: "kamu", audioURL: "nyi.m4a")
    let cu = Word(pinyin: "cu", translation: "masak", audioURL: "cu.m4a"); context.insert(cu)
    let mai = Word(pinyin: "mai", translation: "apa", audioURL: "mai.m4a"); context.insert(mai)
    context.insert(SentenceWord(sentenceID: s1.id, wordID: mak.id, position: 0))
    context.insert(SentenceWord(sentenceID: s1.id, wordID: nyi.id, position: 1))
    context.insert(SentenceWord(sentenceID: s1.id, wordID: cu.id, position: 2))
    context.insert(SentenceWord(sentenceID: s1.id, wordID: mai.id, position: 3))
    
    let choi = Word(pinyin: "choi", translation: "sayur", audioURL: "choi.m4a"); context.insert(choi)
    context.insert(SentenceWord(sentenceID: s2.id, wordID: cu.id, position: 0))
    context.insert(SentenceWord(sentenceID: s2.id, wordID: choi.id, position: 1))

    let an = Word(pinyin: "an", translation: "sekali", audioURL: "an.m4a"); context.insert(an)
    let hoShit = Word(pinyin: "ho shit", translation: "enak", audioURL: "hoshit.m4a"); context.insert(hoShit)
    let nga = Word(pinyin: "nga", translation: "saya", audioURL: "nga-saya.m4a"); context.insert(nga)
    let tushi = Word(pinyin: "tu si", translation: "perut", audioURL: "tushi.m4a"); context.insert(tushi)
    let ki = Word(pinyin: "ki", translation: "lapar", audioURL: "ki.m4a"); context.insert(ki)
    context.insert(SentenceWord(sentenceID: s3.id, wordID: an.id, position: 0))
    context.insert(SentenceWord(sentenceID: s3.id, wordID: hoShit.id, position: 1))
    context.insert(SentenceWord(sentenceID: s3.id, wordID: nga.id, position: 2))
    context.insert(SentenceWord(sentenceID: s3.id, wordID: tushi.id, position: 3))
    context.insert(SentenceWord(sentenceID: s3.id, wordID: ki.id, position: 4))

    let shit = Word(pinyin: "shit", translation: "makan", audioURL: "shit.m4a"); context.insert(shit)
    let liau = Word(pinyin: "liau", translation: "silakan", audioURL: "liau.m4a"); context.insert(liau)
    context.insert(SentenceWord(sentenceID: s4.id, wordID: shit.id, position: 0))
    context.insert(SentenceWord(sentenceID: s4.id, wordID: liau.id, position: 1))
}
