import Foundation
import SwiftData

public func seedChapter1(context: ModelContext) {
    let chapter1 = Chapter(orderIndex: 1, chapterName: "Chapter 1", chapterDescription: "Lama sekali tidak bertemu kamu.")
    context.insert(chapter1)

    let s1 = Sentence(orderIndex: 1, pinyin: "An kiu mo nyi to nyi.", hanzi: "好久不见了。", translation: "Lama sekali tidak bertemu kamu.", audioURL: "c1s1.m4a")
    let s2 = Sentence(orderIndex: 2, pinyin: "He wa ngai kin ha cang biong ka.", hanzi: "是的，我现在正在度假。", translation: "Iya, aku baru libur sekarang.", audioURL: "c1s2.m4a")
    let s3 = Sentence(orderIndex: 3, pinyin: "Abui co she?", hanzi: "你在哪里工作?", translation: "Kamu bekerja dimana?", audioURL: "c1s3.m4a")
    let s4 = Sentence(orderIndex: 4, pinyin: "Ngai han thuk shu. Ha nyian cang thuk chiu.", hanzi: "我还在上大学。明年就毕业了。", translation: "Saya masih kuliah. Tahun depan baru lulus.", audioURL:"c1s4.m4a")
    
    let sentences = [s1, s2, s3, s4]
    sentences.forEach { $0.chapter = chapter1 }
    sentences.forEach { context.insert($0) }
    
    let anKiu = Word(pinyin: "An kiu", translation: "lama sekali", audioURL: "ankiu.m4a"); context.insert(anKiu)
    let mo = Word(pinyin: "mo", translation: "tidak", audioURL: "mo.m4a"); context.insert(mo)
    let nyiTo = Word(pinyin: "nyi to", translation: "bertemu", audioURL: "nyito.m4a"); context.insert(nyiTo)
    let nyi = Word(pinyin: "nyi", translation: "kamu", audioURL: "nyi.m4a"); context.insert(nyi)
    context.insert(SentenceWord(sentenceID: s1.id, wordID: anKiu.id, position: 0))
    context.insert(SentenceWord(sentenceID: s1.id, wordID: mo.id, position: 1))
    context.insert(SentenceWord(sentenceID: s1.id, wordID: nyiTo.id, position: 2))
    context.insert(SentenceWord(sentenceID: s1.id, wordID: nyi.id, position: 3))
    
    let heWa = Word(pinyin: "He wa", translation: "iya", audioURL: "hewa.m4a"); context.insert(heWa)
    let ngai = Word(pinyin: "ngai", translation: "saya", audioURL: "ngai.m4a"); context.insert(ngai)
    let kinHa = Word(pinyin: "kin ha", translation: "sekarang", audioURL: "kinha.m4a"); context.insert(kinHa)
    let cang = Word(pinyin: "cang", translation: "baru", audioURL: "cang.m4a"); context.insert(cang)
    let biongKa = Word(pinyin: "biong ka", translation: "libur", audioURL: "biong.m4a"); context.insert(biongKa)
    context.insert(SentenceWord(sentenceID: s2.id, wordID: heWa.id, position: 0))
    context.insert(SentenceWord(sentenceID: s2.id, wordID: ngai.id, position: 1))
    context.insert(SentenceWord(sentenceID: s2.id, wordID: kinHa.id, position: 2))
    context.insert(SentenceWord(sentenceID: s2.id, wordID: cang.id, position: 3))
    context.insert(SentenceWord(sentenceID: s2.id, wordID: biongKa.id, position: 4))
    
    let abui = Word(pinyin: "Abui", translation: "dimana", audioURL: "abui.m4a"); context.insert(abui)
    let coShe = Word(pinyin: "co she", translation: "bekerja", audioURL: "coshe.m4a"); context.insert(coShe)
    context.insert(SentenceWord(sentenceID: s3.id, wordID: abui.id, position: 0))
    context.insert(SentenceWord(sentenceID: s3.id, wordID: coShe.id, position: 1))
    
    let han = Word(pinyin: "han", translation: "masih", audioURL: "han.m4a"); context.insert(han)
    let thukShu = Word(pinyin: "thuk shu", translation: "sekolah", audioURL: "thukshu.m4a"); context.insert(thukShu)
    let haNyian = Word(pinyin: "ha nyian", translation: "tahun depan", audioURL: "hanyian.m4a"); context.insert(haNyian)
    let thukChiu = Word(pinyin: "thuk chiu", translation: "sekolah", audioURL: "thukchiu.m4a"); context.insert(thukChiu)
    context.insert(SentenceWord(sentenceID: s4.id, wordID: ngai.id, position: 0))
    context.insert(SentenceWord(sentenceID: s4.id, wordID: han.id, position: 1))
    context.insert(SentenceWord(sentenceID: s4.id, wordID: thukShu.id, position: 2))
    context.insert(SentenceWord(sentenceID: s4.id, wordID: haNyian.id, position: 3))
    context.insert(SentenceWord(sentenceID: s4.id, wordID: cang.id, position: 4))
    context.insert(SentenceWord(sentenceID: s4.id, wordID: thukChiu.id, position: 5))
}
