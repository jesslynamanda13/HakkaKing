import Foundation
import SwiftData
public func seedChapter1(context: ModelContext){
    var chapter1 : Chapter = Chapter(orderIndex: 1, chapterName: "Lama sekali tidak bertemu kamu.", chapterDescription: "Obrolan singkat dengan keluarga besar selama liburan.", coverImage: "c1cover")

    let sentence1 = Sentence(orderIndex: 1, pinyin: "An kiu mo nyi to nyi.", hanzi: "好久不见了。", translation: "Lama sekali tidak bertemu kamu.", audioURL: "c1s1.m4a", character: "Paman")
    let sentence2 = Sentence(orderIndex: 2, pinyin: "He wa ngai kin ha cang biong ka.", hanzi: "是的，我现在正在度假。", translation: "Iya, aku baru libur sekarang.", audioURL: "c1s2.m4a", character: "Anak")
    let sentence3 = Sentence(orderIndex: 3, pinyin: "Abui co she?", hanzi: "你在哪里工作?", translation: "Kamu bekerja dimana?", audioURL: "c1s3.m4a", character: "Paman")
    let sentence4 =  Sentence(orderIndex: 4, pinyin: "Ngai han thuk shu. Ha nyian cang thuk chiu.", hanzi: "我还在上大学。明年就毕业了。", translation: "Saya masih kuliah. Tahun depan baru lulus.", audioURL:"c1s4.m4a", character: "Anak")

    // sentence 1
    let anKiu = Word(pinyin: "An kiu", translation: "lama sekali", audioURL: "ankiu.m4a")
    let mo = Word(pinyin: "mo", translation: "tidak", audioURL: "mo.m4a")
    let nyiTo = Word(pinyin: "nyi to", translation: "bertemu", audioURL: "nyito.m4a")
    let nyi = Word(pinyin: "nyi", translation: "kamu", audioURL: "nyi.m4a")
    
    let sw1c1s1 = SentenceWord(sentenceID: sentence1.id, wordID: anKiu.id, position: 0)
    let sw2c1s1 = SentenceWord(sentenceID: sentence1.id, wordID: mo.id, position: 1)
    let sw3c1s1 = SentenceWord(sentenceID: sentence1.id, wordID: nyiTo.id, position: 2)
    let sw4c1s1 = SentenceWord(sentenceID: sentence1.id, wordID: nyi.id, position: 3)
    
    // sentence 2
    let heWa = Word(pinyin: "He wa", translation: "iya", audioURL: "hewa.m4a")
    let ngai = Word(pinyin: "ngai", translation: "saya", audioURL: "ngai.m4a")
    let kinHa = Word(pinyin: "kin ha", translation: "sekarang", audioURL: "kinha.m4a")
    let cang = Word(pinyin: "cang", translation: "baru", audioURL: "cang.m4a")
    let biongKa = Word(pinyin: "biong ka", translation: "libur", audioURL: "biong.m4a")
    
    let sw1c1s2 = SentenceWord(sentenceID: sentence2.id, wordID: heWa.id, position: 0)
    let sw2c1s2 = SentenceWord(sentenceID: sentence2.id, wordID: ngai.id, position: 1)
    let sw3c1s2 = SentenceWord(sentenceID: sentence2.id, wordID: kinHa.id, position: 2)
    let sw4c1s2 = SentenceWord(sentenceID: sentence2.id, wordID: cang.id, position: 3)
    let sw5c1s2 = SentenceWord(sentenceID: sentence2.id, wordID: biongKa.id, position: 4)
                     
    
    // sentence 3
    let abui = Word(pinyin: "Abui", translation: "dimana", audioURL: "abui.m4a")
    let coShe = Word(pinyin: "co she", translation: "bekerja", audioURL: "coshe.m4a")
    
    let sw1c1s3 = SentenceWord(sentenceID: sentence3.id, wordID: abui.id, position: 0)
    let sw2c1s3 = SentenceWord(sentenceID: sentence3.id, wordID: coShe.id, position: 1)
    
    // sentence 4
    let han = Word(pinyin: "han", translation: "masih", audioURL: "han.m4a")
    let thukShu = Word(pinyin: "thuk shu", translation: "sekolah", audioURL: "thukshu.m4a")
    let haNyian = Word(pinyin: "ha nyian", translation: "tahun depan", audioURL: "hanyian.m4a")
    let thukChiu = Word(pinyin: "thuk chiu", translation: "sekolah", audioURL: "thukchiu.m4a")
    
    let sw1c1s4 = SentenceWord(sentenceID: sentence4.id, wordID: ngai.id, position: 0)
    let sw2c1s4 = SentenceWord(sentenceID: sentence4.id, wordID: han.id, position: 1)
    let sw3c1s4 = SentenceWord(sentenceID: sentence4.id, wordID: thukShu.id, position: 2)
    let sw4c1s4 = SentenceWord(sentenceID: sentence4.id, wordID: haNyian.id, position: 3)
    let sw5c1s4 = SentenceWord(sentenceID: sentence4.id, wordID: cang.id, position: 4)
    let sw6c1s4 = SentenceWord(sentenceID: sentence4.id, wordID: thukChiu.id, position: 5)
    
    // Insert to database
    // All Sentences
    context.insert(sentence1)
    context.insert(sentence2)
    context.insert(sentence3)
    context.insert(sentence4)
    
    // Sentence-Word 1
    context.insert(anKiu)
    context.insert(mo)
    context.insert(nyiTo)
    context.insert(nyi)
    
    context.insert(sw1c1s1)
    context.insert(sw2c1s1)
    context.insert(sw3c1s1)
    context.insert(sw4c1s1)
    
    // Sentence-Word 2
    context.insert(heWa)
    context.insert(ngai)
    context.insert(kinHa)
    context.insert(cang)
    context.insert(biongKa)
    
    context.insert(sw1c1s2)
    context.insert(sw2c1s2)
    context.insert(sw3c1s2)
    context.insert(sw4c1s2)
    
    // Sentence-Word 3
    context.insert(abui)
    context.insert(coShe)
    
    context.insert(sw1c1s3)
    context.insert(sw2c1s3)
    
    // Sentence-Word 4
    context.insert(han)
    context.insert(thukShu)
    context.insert(haNyian)
    context.insert(thukChiu)
    
    context.insert(sw1c1s4)
    context.insert(sw2c1s4)
    context.insert(sw3c1s4)
    context.insert(sw4c1s4)
    context.insert(sw5c1s4)
    context.insert(sw6c1s4)
    
    
    chapter1.sentences = [sentence1.id, sentence2.id, sentence3.id, sentence4.id]
    context.insert(chapter1)
}
