import Foundation
import SwiftData

public func seedChapter3(context:ModelContext){
    var chapter3: Chapter = Chapter(orderIndex: 3, chapterName: "Habis ngapain hari ini?", chapterDescription: "Ngobrol dengan papa setelah seharian beraktivitas", coverImage: "c3cover")
    
    let sentence1 = Sentence(orderIndex:1, pinyin: "Ki nyit ngai an hot.", hanzi: "我今天好累啊。", translation: "Aku lelah sekali hari ini.", audioURL: "c3s1.m4a", character: "Anak")
    let sentence2 = Sentence(orderIndex: 2, pinyin: "Nyi co li mai?", hanzi: "你最近都在做什么？", translation: "Kamu habis ngapain?", audioURL:"c3s2.m4a", character: "Ayah")
    let sentence3 = Sentence(orderIndex: 3, pinyin: "Ngai cha am mo soi muk, co shang she.", hanzi: "我昨晚没睡，在做某事。", translation: "Aku tidak tidur semalam, mengerjakan sesuatu.", audioURL: "c3s3.m4a", character: "Anak")
    let sentence4 = Sentence(orderIndex:4, pinyin: "Kin ha soi muk liau.", hanzi: "现在去睡觉吧。", translation: "Sekarang tidurlah.", audioURL: "c3s4.m4a", character: "Ayah")
    
    //sentence 1
    let ki = Word(pinyin: "ki", translation: "ini", audioURL: "ki-ini.m4a")
    let nyit = Word(pinyin: "nyit", translation: "hari", audioURL: "nyit.m4a")
    let ngai = Word(pinyin: "ngai", translation: "saya", audioURL: "ngai.m4a")
    let an = Word(pinyin: "an", translation: "sekali", audioURL: "an.4a")
    let hot = Word(pinyin: "hot", translation: "lelah", audioURL: "hot.m4a")
    
    let sw1c3s1 = SentenceWord(sentenceID: sentence1.id, wordID: ki.id, position: 0)
    let sw2c3s1 = SentenceWord(sentenceID: sentence1.id, wordID: nyit.id, position: 1)
    let sw3c3s1 = SentenceWord(sentenceID: sentence1.id, wordID: ngai.id, position: 2)
    let sw4c3s1 = SentenceWord(sentenceID: sentence1.id, wordID: an.id, position: 3)
    let sw5c3s1 = SentenceWord(sentenceID: sentence1.id, wordID: hot.id, position: 4)
    
    // sentence 2
    let nyi = Word(pinyin: "nyi", translation: "kamu", audioURL: "nyi.m4a")
    let co = Word(pinyin: "co", translation: "kerja", audioURL: "co.m4a")
    let li = Word(pinyin: "li", translation: "habis", audioURL: "li.m4a")
    let mai = Word(pinyin: "mai", translation: "apa", audioURL: "mai.m4a")
    
    let sw1c3s2 = SentenceWord(sentenceID: sentence2.id, wordID: nyi.id, position: 0)
    let sw2c3s2 = SentenceWord(sentenceID: sentence2.id, wordID: co.id, position: 1)
    let sw3c3s2 = SentenceWord(sentenceID: sentence2.id, wordID: li.id, position: 2)
    let sw4c3s2 = SentenceWord(sentenceID: sentence2.id, wordID: mai.id, position: 3)
    
    // sentence 3
    let chaAm = Word(pinyin: "cha am", translation: "saya tidak", audioURL: "chaam.m4a")
    let mo = Word(pinyin: "mo", translation: "waktu", audioURL: "mo.m4a")
    let soiMuk = Word(pinyin: "soi muk", translation: "tidur", audioURL: "soimuk.m4a")
    let shangshe = Word(pinyin: "shang she", translation: "dan", audioURL: "shangshe.m4a")
    
    let sw1c3s3 = SentenceWord(sentenceID: sentence3.id, wordID: ngai.id, position: 0)
    let sw2c3s3 = SentenceWord(sentenceID: sentence3.id, wordID: chaAm.id, position: 1)
    let sw3c3s3 = SentenceWord(sentenceID: sentence3.id, wordID: mo.id, position: 2)
    let sw4c3s3 = SentenceWord(sentenceID: sentence3.id, wordID: soiMuk.id, position: 3)
    let sw5c3s3 = SentenceWord(sentenceID: sentence3.id, wordID: co.id, position: 4)
    let sw6c3s3 = SentenceWord(sentenceID: sentence3.id, wordID: shangshe.id, position: 5)
    
    // sentence 4
    let kinHa = Word(pinyin: "kin ha", translation: "sekarang", audioURL: "kinha.m4a")
    let liau = Word(pinyin: "liau", translation: "silakan", audioURL: "liau.m4a")
    
    let sw1c3s4 = SentenceWord(sentenceID: sentence4.id, wordID: kinHa.id, position: 0)
    let sw2c3s4 = SentenceWord(sentenceID: sentence4.id, wordID: soiMuk.id, position: 1)
    let sw3c3s4 = SentenceWord(sentenceID: sentence4.id, wordID: liau.id, position: 2)
    
    // insert database
    context.insert(sentence1)
    context.insert(sentence2)
    context.insert(sentence3)
    context.insert(sentence4)
    
    // Sentence-Word 1
    context.insert(ki)
    context.insert(nyit)
    context.insert(ngai)
    context.insert(an)
    context.insert(hot)
    
    context.insert(sw1c3s1)
    context.insert(sw2c3s1)
    context.insert(sw3c3s1)
    context.insert(sw4c3s1)
    context.insert(sw5c3s1)
    
    // Sentence-Word 2
    context.insert(nyi)
    context.insert(co)
    context.insert(li)
    context.insert(mai)
    
    context.insert(sw1c3s2)
    context.insert(sw2c3s2)
    context.insert(sw3c3s2)
    
    // Sentence-Word 3
    context.insert(chaAm)
    context.insert(mo)
    context.insert(soiMuk)
    context.insert(shangshe)
    
    context.insert(sw1c3s3)
    context.insert(sw2c3s3)
    context.insert(sw3c3s3)
    context.insert(sw4c3s3)
    context.insert(sw5c3s3)
    context.insert(sw6c3s3)
    
    // Sentence-Word 4
    context.insert(kinHa)
    context.insert(liau)
    
    context.insert(sw1c3s4)
    context.insert(sw2c3s4)
    context.insert(sw3c3s4)
    
    chapter3.sentences = [sentence1.id, sentence2.id, sentence3.id, sentence4.id]
    context.insert(chapter3)
    
}
