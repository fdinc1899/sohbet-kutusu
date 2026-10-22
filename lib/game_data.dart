import 'package:flutter/material.dart';

enum GameMode { dilemma, likely, countdown, challenge }

extension GameModeInfo on GameMode {
  String get title => switch (this) {
        GameMode.dilemma => 'İkilem',
        GameMode.likely => 'Kim Daha Olası?',
        GameMode.countdown => '5 Saniyede Söyle',
        GameMode.challenge => 'Eğlenceli Görevler',
      };

  String get subtitle => switch (this) {
        GameMode.dilemma => 'Birini seç, arkadaşlarını tanı',
        GameMode.likely => 'Grupça oy verin',
        GameMode.countdown => 'Hızlı düşün, hızlı konuş',
        GameMode.challenge => 'Komik mini görevleri dene',
      };

  IconData get icon => switch (this) {
        GameMode.dilemma => Icons.call_split_rounded,
        GameMode.likely => Icons.groups_rounded,
        GameMode.countdown => Icons.timer_rounded,
        GameMode.challenge => Icons.celebration_rounded,
      };

  Color get accent => switch (this) {
        GameMode.dilemma => const Color(0xFFBC8CFF),
        GameMode.likely => const Color(0xFFFFB56A),
        GameMode.countdown => const Color(0xFF5DE0C8),
        GameMode.challenge => const Color(0xFFFF789C),
      };

  String get instructions => switch (this) {
        GameMode.dilemma => 'Ekrandaki iki seçenekten birini seç. Arkadaşların da sırayla cevaplasın. En şaşırtıcı cevapları tartışın.',
        GameMode.likely => 'Soruyu yüksek sesle oku. Herkes kendisine en uygun gelen kişiyi göstersin. Sonra yeni karta geçin.',
        GameMode.countdown => 'Başlat’a bas. Süre bitmeden istenen üç örneği söylemeye çalış. Yetiştirirsen “Başardım”a dokun.',
        GameMode.challenge => 'Karttaki küçük görevi isteyen oyuncu yapsın. Herkes pas geçmekte özgürdür.',
      };
}

class Dilemma {
  final String left;
  final String right;
  const Dilemma(this.left, this.right);
}

const dilemmas = <Dilemma>[
  Dilemma('Her dili konuşmak', 'Her enstrümanı çalmak'),
  Dilemma('Deniz kenarında yaşamak', 'Dağ evinde yaşamak'),
  Dilemma('Zamanı durdurmak', 'Uçabilmek'),
  Dilemma('Bir yıl tatil yapmak', 'Hayalindeki işi yapmak'),
  Dilemma('Geçmişe yolculuk', 'Geleceği görmek'),
  Dilemma('Kedilerle konuşmak', 'Köpeklerle konuşmak'),
  Dilemma('Hep yaz olsun', 'Hep kış olsun'),
  Dilemma('Süper hızlı olmak', 'Görünmez olmak'),
  Dilemma('Kitapta yaşamak', 'Filmde yaşamak'),
  Dilemma('Uzayda yürümek', 'Okyanusun dibine inmek'),
  Dilemma('Her gün yeni yemek', 'Her gün favori yemek'),
  Dilemma('Şarkıcı olmak', 'Oyuncu olmak'),
  Dilemma('Telefon olmadan bir hafta', 'İnternet olmadan bir hafta'),
  Dilemma('Çok erken uyanmak', 'Çok geç uyumak'),
  Dilemma('Dünyayı trenle gezmek', 'Dünyayı gemiyle gezmek'),
  Dilemma('Bir gün kraliçe/kral olmak', 'Bir gün astronot olmak'),
  Dilemma('Sonsuz pizza', 'Sonsuz dondurma'),
  Dilemma('Şehirde küçük ev', 'Köyde büyük ev'),
  Dilemma('Daima şanslı olmak', 'Daima hazırlıklı olmak'),
  Dilemma('Tüm sporları bilmek', 'Tüm dansları bilmek'),
  Dilemma('Her gün sürpriz', 'Her gün sakinlik'),
  Dilemma('Eski bir kalede yaşamak', 'Modern bir kulede yaşamak'),
  Dilemma('Fotoğraf hafızası', 'Mükemmel yön duygusu'),
  Dilemma('Daha çok boş zaman', 'Daha çok seyahat'),
  Dilemma('Gün doğumunu izlemek', 'Gün batımını izlemek'),
  Dilemma('Tatlı kahvaltı', 'Tuzlu kahvaltı'),
  Dilemma('Herkesin güldüğü şaka', 'Herkesin sevdiği şarkı'),
  Dilemma('Ormanda kamp', 'Sahilde kamp'),
  Dilemma('Bisikletle gezmek', 'Kaykayla gezmek'),
  Dilemma('Evde sinema gecesi', 'Açık hava konseri'),
  Dilemma('Her oyunda kazanmak', 'Her sınavda tam puan'),
  Dilemma('Bütün müzeleri gezmek', 'Bütün parkları gezmek'),
];

const likelyQuestions = <String>[
  'Bir şarkıyı ilk dinleyişte ezberleyen kim olur?',
  'Bir yolculukta yanlış yöne giden kim olur?',
  'Sürpriz doğum günü planını yapan kim olur?',
  'En komik fotoğrafı çeken kim olur?',
  'Her ortamda yeni arkadaş edinen kim olur?',
  'Telefonunu evde unutan kim olur?',
  'Sabaha kadar dizi izleyen kim olur?',
  'Bir gün ünlü bir şef olan kim olur?',
  'En çabuk gülmeye başlayan kim olur?',
  'Tatil valizini son dakika hazırlayan kim olur?',
  'Şarkı sözlerini yanlış söyleyen kim olur?',
  'Grubun fotoğrafçısı olan kim olur?',
  'Herkesten önce dans etmeye başlayan kim olur?',
  'Her oyunun kurallarını ilk çözen kim olur?',
  'Bir kitabı tek gecede bitiren kim olur?',
  'En yaratıcı hediye seçen kim olur?',
  'Sürpriz bir yarışmaya katılan kim olur?',
  'Her hafta yeni bir hobi deneyen kim olur?',
  'Gülmekten konuşamayan kim olur?',
  'En iyi gezi planını yapan kim olur?',
  'Yanında hep atıştırmalık taşıyan kim olur?',
  'Filmin sonunu erkenden tahmin eden kim olur?',
  'Bir bitkiyi yıllarca yaşatan kim olur?',
  'Tüm grubu sabah spora çağıran kim olur?',
  'Bir hayvan barınağında gönüllü olan kim olur?',
  'Kameraya bakmadan fotoğraf veren kim olur?',
  'Oyun gecesini organize eden kim olur?',
  'Yanlışlıkla sesli mesaj gönderen kim olur?',
  'En çok farklı dil öğrenen kim olur?',
  'Bir gün kendi kafesini açan kim olur?',
  'Dans hareketi uyduran kim olur?',
  'Yeni bir şehirde hemen yol bulan kim olur?',
];

const fiveSecondQuestions = <String>[
  'Üç sarı eşya söyle!',
  'Üç deniz canlısı söyle!',
  'Üç çizgi film karakteri söyle!',
  'Üç yuvarlak nesne söyle!',
  'Üç kahvaltılık söyle!',
  'Üç tatil şehri söyle!',
  'Üç dans türü söyle!',
  'Üç çiçek adı söyle!',
  'Üç kış sporu söyle!',
  'Üç uçan şey söyle!',
  'Üç meyve suyu çeşidi söyle!',
  'Üç mutfak eşyası söyle!',
  'Üç turuncu şey söyle!',
  'Üç süper kahraman söyle!',
  'Üç sokak hayvanı söyle!',
  'Üç müzik aleti söyle!',
  'Üç mevsimlik kıyafet söyle!',
  'Üç masa oyunu söyle!',
  'Üç deniz kenarı etkinliği söyle!',
  'Üç park oyunu söyle!',
  'Üç gezi çantası eşyası söyle!',
  'Üç çorba çeşidi söyle!',
  'Üç spor topu söyle!',
  'Üç fantastik yaratık söyle!',
  'Üç mavi eşya söyle!',
  'Üç sıcak içecek söyle!',
  'Üç soğuk tatlı söyle!',
  'Üç ülkede konuşulan dil söyle!',
  'Üç ulaşım aracı söyle!',
  'Üç yeşil sebze söyle!',
  'Üç dağ sporu söyle!',
  'Üç evcil hayvan söyle!',
];

const challengeQuestions = <String>[
  'Bir robot gibi 10 saniye konuş.',
  'Kimseye dokunmadan komik bir dans yap.',
  'En sevdiğin yemeği reklam sesiyle tanıt.',
  'Bir hayvanı ses çıkarmadan taklit et.',
  'Bir masalın sonunu tek cümlede değiştir.',
  'İki cümlelik komik bir haber sun.',
  'Odadaki bir nesneyi süper kahraman ilan et.',
  'Bir şarkıyı sadece mırıldanarak anlat.',
  'Hayali bir ödül töreni konuşması yap.',
  'Bir arkadaşına üç güzel özellik söyle.',
  'Günlük bir işi ağır çekimde canlandır.',
  'Bir çizgi film karakteri gibi selam ver.',
  'Bir kedinin günlüğünden bir cümle oku.',
  'Bir uzaylı gibi “merhaba” de.',
  'Hayali bir spor için tezahürat üret.',
  'Kendi icat ettiğin sözcüğe anlam bul.',
  'Bir nesnenin gözünden mini hikâye anlat.',
  '10 saniyelik sessiz bir komedi sahnesi yap.',
  'Bir filmin adını mimikle anlat.',
  'Bir pastane için eğlenceli slogan bul.',
  'Hayalindeki gezegenin adını söyle.',
  'Bir dakikalık değil, tek cümlelik şiir yaz.',
  'Bir meyveye süper güç ver ve anlat.',
  'Günün hava durumunu spiker gibi sun.',
  'Bir arkadaşını kahraman gibi tanıt.',
  'Bir bilmece uydur ve sor.',
  'Hayali bir konseri açılış cümlesiyle başlat.',
  'Bir kuş gibi sevinç gösterisi yap.',
  'Görünmez bir kutudan hediye çıkar.',
  'Bir ev eşyası için komik reklam sloganı bul.',
  'Bir kelimeyi üç farklı duyguyla söyle.',
  'En eğlenceli selamlaşma hareketini tasarla.',
];
