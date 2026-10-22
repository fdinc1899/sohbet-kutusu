# Sohbet Kutusu V1 🎉

Flutter ile hazırlanmış, Android için eğlenceli arkadaş grubu oyunu.

## İçerik

- Dört çalışır oyun modu: İkilem, Kim Daha Olası?, 5 Saniyede Söyle, Eğlenceli Görevler
- Her modda 32 farklı kart; toplam **128 kart**
- Karıştırılan kart destesi, tekrarları bitene kadar göstermemeye çalışma
- Çalışan 5 saniyelik sayaç ve başarı/başarısızlık ekranı
- Günlük 10 kart hedefi, giriş serisi, oynanan kart sayısı, seviye
- Cihazda yerel kayıt: `shared_preferences`
- Soruyu panoya kopyalama
- Tamamen çevrimdışı içerik, üyelik gerektirmez
- Flutter widget testleri
- GitHub Actions ile otomatik Android APK derlemesi

## Kaynak dosyaları

`lib/main.dart`, `lib/game_data.dart`, `pubspec.yaml`, `test/widget_test.dart`, `.github/workflows/android-apk.yml`.

**Not:** Android'in yerel Gradle dosyaları ZIP'e konulmadı; CI iş akışı `flutter create . --platforms=android --org=com.sohbetkutusu` komutuyla otomatik oluşturur. Bu nedenle ZIP'i doğrudan Android Studio'da açmadan önce aynı komutu çalıştırın.

## GitHub'a yükleme ve APK indirme

1. GitHub'da **sohbet-kutusu** adlı boş bir depo oluşturun (Private önerilir).
2. ZIP'i açın. İçindeki dosya ve klasörleri **deponun köküne** yükleyin; ZIP'i tek dosya olarak koymayın. Gizli `.github` klasörünü de mutlaka yükleyin.
3. Depoda **Actions** sekmesini açın. `Android APK Olustur` iş akışını seçip `Run workflow` düğmesine basın. Push sırasında da tetiklenir.
4. Derleme başarılı olursa iş akışının **Artifacts** bölümünde `SohbetKutusu-V1-Android-APK` yer alır. ZIP'i indirip içindeki `app-release.apk` dosyasını Android telefona yükleyin.
5. Windows/Mac/Linux'ta yerel derleme için Flutter kurulu dizinde:

```bash
flutter create . --platforms=android --org=com.sohbetkutusu
flutter pub get
flutter test
flutter build apk --release
```

## Google Play ve gelir modeli

Bu paket **çalışır bir V1 prototipidir**; **gerçek AdMob reklamları ekli değildir**. İlk APK'da reklam gösterilmez, gelir oluşmaz. Reklam SDK'sı ve gerçek kimlikler, Google Play uyumlu izinler ve gizlilik politikası bir sonraki aşamada eklenmelidir. Ödüllü reklamlar sadece kullanıcının isteğiyle, tam ekran reklamlar oyun turları arasındaki doğal geçişlerde gösterilmelidir.

Google Play'e yüklemek için ayrıca Android App Bundle (AAB), benzersiz applicationId, sürüm/imzalama yapılandırması, mağaza açıklaması, ikon, ekran görüntüleri, veri güvenliği beyanı ve gerekliyse test gereklidir. Bu ZIP doğrudan Play'de yayımlanmaya hazır değildir.

## Önemli

- Oyun soruları özgün olarak yazıldı. Dışarıdan indirilmiş/telifli görsel kullanılmaz.
- Puanlar kullanıcı katılımını gösterir; rekabetçi bir hile koruması yoktur.
- Yalnızca yerel kayıt vardır, bulut yedekleme yoktur.
- Uygulama henüz gerçek Android cihazda derlenip test edilmedi. GitHub Actions derlemesi bunu doğrulayacaktır.
