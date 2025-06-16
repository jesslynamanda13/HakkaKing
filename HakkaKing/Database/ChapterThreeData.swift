import Foundation
import SwiftData

public func seedChapter3(context:ModelContext){
    let chapter3 = Chapter(orderIndex: 3, chapterName: "Chapter 3", chapterDescription: "Aku lelah sekali hari ini.")
    context.insert(chapter3)
    
    let s1 = Sentence(orderIndex:1, pinyin: "Ki nyit ngai an hot.", hanzi: "我今天好累啊。", translation: "Aku lelah sekali hari ini.", audioURL: "c3s1.m4a")
    let s2 = Sentence(orderIndex: 2, pinyin: "Nyi co li mai?", hanzi: "你最近都在做什么？", translation: "Kamu habis ngapain?", audioURL:"c3s2.m4a")
    let s3 = Sentence(orderIndex: 3, pinyin: "Ngai cha am mo soi muk, co shang she.", hanzi: "我昨晚没睡，在做某事。", translation: "Aku tidak tidur semalam, mengerjakan sesuatu.", audioURL: "c3s3.m4a")
    let s4 = Sentence(orderIndex:4, pinyin: "Kin ha soi muk liau.", hanzi: "现在去睡觉吧。", translation: "Sekarang tidurlah.", audioURL: "c3s4.m4a")
    let sentences = [s1, s2, s3, s4]
    sentences.forEach { $0.chapter = chapter3 }
    sentences.forEach { context.insert($0) }

    // Sentence 1 Words
    let ki = Word(pinyin: "ki", translation: "ini", audioURL: "ki-ini.m4a"); context.insert(ki)
    let nyit = Word(pinyin: "nyit", translation: "hari", audioURL: "nyit.m4a"); context.insert(nyit)
    let ngai = Word(pinyin: "ngai", translation: "saya", audioURL: "ngai.m4a"); context.insert(ngai)
    let an = Word(pinyin: "an", translation: "sekali", audioURL: "an.4a"); context.insert(an)
    let hot = Word(pinyin: "hot", translation: "lelah", audioURL: "hot.m4a"); context.insert(hot)
    context.insert(SentenceWord(sentenceID: s1.id, wordID: ki.id, position: 0))
    context.insert(SentenceWord(sentenceID: s1.id, wordID: nyit.id, position: 1))
    context.insert(SentenceWord(sentenceID: s1.id, wordID: ngai.id, position: 2))
    context.insert(SentenceWord(sentenceID: s1.id, wordID: an.id, position: 3))
    context.insert(SentenceWord(sentenceID: s1.id, wordID: hot.id, position: 4))
    
    // Sentence 2 Words
    let nyi = Word(pinyin: "nyi", translation: "kamu", audioURL: "nyi.m4a"); context.insert(nyi) // FIX: This word is now inserted
    let co = Word(pinyin: "co", translation: "kerja", audioURL: "co.m4a"); context.insert(co)
    let li = Word(pinyin: "li", translation: "habis", audioURL: "li.m4a"); context.insert(li)
    let mai = Word(pinyin: "mai", translation: "apa", audioURL: "mai.m4a"); context.insert(mai)
    context.insert(SentenceWord(sentenceID: s2.id, wordID: nyi.id, position: 0))
    context.insert(SentenceWord(sentenceID: s2.id, wordID: co.id, position: 1))
    context.insert(SentenceWord(sentenceID: s2.id, wordID: li.id, position: 2))
    context.insert(SentenceWord(sentenceID: s2.id, wordID: mai.id, position: 3))

    // Sentence 3 Words
    let chaAm = Word(pinyin: "cha am", translation: "saya tidak", audioURL: "chaam.m4a"); context.insert(chaAm)
    let mo = Word(pinyin: "mo", translation: "waktu", audioURL: "mo.m4a"); context.insert(mo)
    let soiMuk = Word(pinyin: "soi muk", translation: "tidur", audioURL: "soimuk.m4a"); context.insert(soiMuk)
    let shangshe = Word(pinyin: "shang she", translation: "dan", audioURL: "shangshe.m4a"); context.insert(shangshe)
    context.insert(SentenceWord(sentenceID: s3.id, wordID: ngai.id, position: 0))
    context.insert(SentenceWord(sentenceID: s3.id, wordID: chaAm.id, position: 1))
    context.insert(SentenceWord(sentenceID: s3.id, wordID: mo.id, position: 2))
    context.insert(SentenceWord(sentenceID: s3.id, wordID: soiMuk.id, position: 3))
    context.insert(SentenceWord(sentenceID: s3.id, wordID: co.id, position: 4))
    context.insert(SentenceWord(sentenceID: s3.id, wordID: shangshe.id, position: 5))

    // Sentence 4 Words
    let kinHa = Word(pinyin: "kin ha", translation: "sekarang", audioURL: "kinha.m4a"); context.insert(kinHa)
    let liau = Word(pinyin: "liau", translation: "silakan", audioURL: "liau.m4a"); context.insert(liau)
    context.insert(SentenceWord(sentenceID: s4.id, wordID: kinHa.id, position: 0))
    context.insert(SentenceWord(sentenceID: s4.id, wordID: soiMuk.id, position: 1))
    context.insert(SentenceWord(sentenceID: s4.id, wordID: liau.id, position: 2))
}
