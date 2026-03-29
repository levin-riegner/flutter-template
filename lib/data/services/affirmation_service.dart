import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/data/services/storage_service.dart';

class AffirmationService {
  final StorageService _storage;

  AffirmationService(this._storage);

  // ─── Predefined Affirmations (~30 per category, 210+ total) ───

  static final List<Affirmation> _allAffirmations = [
    // Self Love (30)
    ..._cat(AffirmationCategory.selfLove, [
      'I am worthy of love and respect.',
      'I love and accept myself unconditionally.',
      'I am enough, just as I am.',
      'My self-worth is not determined by others.',
      'I deserve kindness, especially from myself.',
      'I am beautiful inside and out.',
      'I honor my body and treat it with care.',
      'I forgive myself for past mistakes.',
      'I am proud of who I am becoming.',
      'I radiate love and it returns to me.',
      'I choose to see the beauty in myself.',
      'I am at peace with who I am.',
      'My imperfections make me unique.',
      'I am deserving of all good things.',
      'I trust myself and my abilities.',
      'I speak to myself with love and compassion.',
      'I am a gift to the world.',
      'I celebrate my strengths every day.',
      'I let go of negative self-talk.',
      'I am worthy of my own love.',
      'Every cell in my body radiates love.',
      'I am gentle with myself always.',
      'I choose self-love over self-criticism.',
      'I am complete as I am right now.',
      'I value myself and my boundaries.',
      'My heart is open to receiving love.',
      'I appreciate everything my body does for me.',
      'I am learning to love myself more each day.',
      'I release the need for approval from others.',
      'I am my own best friend.',
    ]),
    // Abundance (30)
    ..._cat(AffirmationCategory.abundance, [
      'I am a magnet for abundance and prosperity.',
      'Money flows to me easily and effortlessly.',
      'I am open to receiving unlimited wealth.',
      'I deserve financial freedom.',
      'Abundance is my natural state of being.',
      'I attract opportunities that create wealth.',
      'I am grateful for the abundance in my life.',
      'Prosperity is drawn to me from all directions.',
      'I release all blocks to receiving abundance.',
      'My income is constantly increasing.',
      'I am worthy of financial success.',
      'I create value and abundance follows.',
      'The universe supports my financial goals.',
      'I am aligned with the energy of wealth.',
      'I think abundantly and live abundantly.',
      'Every dollar I spend comes back multiplied.',
      'I am financially free and secure.',
      'Wealth constantly flows into my life.',
      'I welcome new sources of income.',
      'I am a conscious and wise steward of money.',
      'My wealth allows me to help others.',
      'I deserve to be paid well for my work.',
      'Abundance surrounds me in every area of life.',
      'I release fear around money.',
      'I am open to all the wealth life offers me.',
      'My bank account grows every single day.',
      'I have more than enough for everything I need.',
      'Financial abundance is my birthright.',
      'I attract wealth with positive energy.',
      'I am grateful for every blessing in my life.',
    ]),
    // Health (30)
    ..._cat(AffirmationCategory.health, [
      'My body is healthy, strong, and full of energy.',
      'I nourish my body with healthy choices.',
      'Every cell in my body vibrates with health.',
      'I am grateful for my healthy body.',
      'I listen to my body and give it what it needs.',
      'My immune system is strong and powerful.',
      'I choose foods that heal and energize me.',
      'I sleep deeply and wake up refreshed.',
      'My body has an amazing ability to heal itself.',
      'I radiate health and vitality.',
      'I am becoming healthier every single day.',
      'I treat my body like a temple.',
      'My mind and body are in perfect harmony.',
      'I release all tension and stress from my body.',
      'I am full of energy and vitality.',
      'Healing energy flows through every part of me.',
      'I make choices that support my well-being.',
      'My body is a wonderful instrument of life.',
      'I am at peace with my body.',
      'I breathe deeply and feel alive.',
      'Every breath I take fills me with healing energy.',
      'I am patient with my healing journey.',
      'My body knows how to heal, and I trust it.',
      'I choose movement that brings me joy.',
      'I honor my body with rest when I need it.',
      'I am connected to my body and its wisdom.',
      'I release habits that no longer serve my health.',
      'I am worthy of vibrant health.',
      'My body grows stronger with each passing day.',
      'I embrace a lifestyle of wellness and joy.',
    ]),
    // Relationships (30)
    ..._cat(AffirmationCategory.relationships, [
      'I attract loving and supportive relationships.',
      'I am worthy of deep, meaningful connections.',
      'My relationships are filled with love and respect.',
      'I communicate openly and honestly.',
      'I attract people who uplift and inspire me.',
      'I give and receive love freely.',
      'I am a magnet for healthy relationships.',
      'I deserve to be treated with kindness.',
      'My heart is open to love.',
      'I set healthy boundaries with love.',
      'I forgive those who have hurt me and release them.',
      'I am surrounded by people who care about me.',
      'I nurture my relationships with attention and love.',
      'I attract my ideal partner effortlessly.',
      'I am grateful for the love in my life.',
      'My relationships bring out the best in me.',
      'I communicate my needs clearly and kindly.',
      'I let go of relationships that drain my energy.',
      'I am loved exactly as I am.',
      'I bring joy and positivity to my relationships.',
      'I trust in the power of love to heal.',
      'I am open to new friendships and connections.',
      'My love life is full of happiness and passion.',
      'I choose partners who respect and value me.',
      'I am a loving and compassionate person.',
      'I create deep and lasting connections.',
      'Love flows to me and through me effortlessly.',
      'I am worthy of a fulfilling partnership.',
      'I release the need to control others.',
      'I celebrate the uniqueness of each relationship.',
    ]),
    // Career (30)
    ..._cat(AffirmationCategory.career, [
      'I am successful in everything I do.',
      'My career is aligned with my purpose.',
      'I attract amazing opportunities.',
      'I am confident in my professional abilities.',
      'I deserve success and recognition.',
      'My work makes a positive impact on the world.',
      'I am a natural leader.',
      'I turn challenges into opportunities for growth.',
      'My skills and talents are valuable.',
      'I am passionate about my work.',
      'Success comes naturally to me.',
      'I am open to new career possibilities.',
      'I create my own success story.',
      'My career grows in fulfilling ways.',
      'I am motivated, persistent, and successful.',
      'I bring creativity and innovation to my work.',
      'I attract mentors who guide me to success.',
      'My hard work always pays off.',
      'I am worthy of promotions and raises.',
      'I trust the timing of my career journey.',
      'I am building the career of my dreams.',
      'Every day I become better at what I do.',
      'I am a valuable member of my team.',
      'My potential is limitless.',
      'I embrace new challenges with confidence.',
      'I am proud of my professional achievements.',
      'My career brings me joy and fulfillment.',
      'I attract clients and projects that excite me.',
      'I am fearless in the pursuit of my goals.',
      'I balance ambition with well-being.',
    ]),
    // Confidence (30)
    ..._cat(AffirmationCategory.confidence, [
      'I believe in myself and my abilities.',
      'I am confident, capable, and strong.',
      'I radiate confidence and self-assurance.',
      'I trust my intuition and follow my heart.',
      'I am brave and stand up for myself.',
      'My confidence grows stronger every day.',
      'I am not afraid to take up space.',
      'I speak my truth with courage and clarity.',
      'I am worthy of success and happiness.',
      'I face my fears with strength and determination.',
      'I am unstoppable when I set my mind to something.',
      'My voice matters and deserves to be heard.',
      'I step outside my comfort zone with excitement.',
      'I am the architect of my own life.',
      'I handle every situation with grace and confidence.',
      'I release self-doubt and embrace self-belief.',
      'I am powerful beyond measure.',
      'I walk into every room with confidence.',
      'I am not defined by my past.',
      'I choose to be bold and courageous.',
      'My self-confidence inspires others.',
      'I deserve to take up space in this world.',
      'I am comfortable being the center of attention.',
      'I replace fear with faith in myself.',
      'I am resilient and can handle anything.',
      'I celebrate my victories, big and small.',
      'I am worthy of achieving my wildest dreams.',
      'I trust myself to make the right decisions.',
      'I am becoming more confident every single day.',
      'I own my power and use it wisely.',
    ]),
    // Peace (30)
    ..._cat(AffirmationCategory.peace, [
      'I am at peace with myself and the world.',
      'I release all worry and embrace calm.',
      'Peace flows through me like a gentle river.',
      'I choose peace over anxiety.',
      'My mind is calm and my heart is at ease.',
      'I let go of what I cannot control.',
      'I am centered, grounded, and at peace.',
      'I breathe in peace and breathe out stress.',
      'I create a peaceful environment around me.',
      'I am safe and all is well in my world.',
      'I release the past and live in the present moment.',
      'Serenity and tranquility fill my soul.',
      'I am calm in the midst of any storm.',
      'I forgive and find peace within.',
      'I deserve a life of peace and harmony.',
      'My inner peace is unshakeable.',
      'I attract peaceful and positive experiences.',
      'I am grateful for the stillness within me.',
      'I release negativity and embrace peace.',
      'I find peace in every moment of my day.',
      'I am a peaceful presence in the lives of others.',
      'I trust the journey and find peace in uncertainty.',
      'My thoughts are peaceful and kind.',
      'I choose harmony in all my interactions.',
      'I am connected to an infinite source of peace.',
      'I let go of drama and embrace tranquility.',
      'Peace is my superpower.',
      'I am patient with myself and others.',
      'I cultivate inner peace through daily practice.',
      'I am the calm in any storm.',
    ]),
  ];

  static List<Affirmation> _cat(AffirmationCategory cat, List<String> texts) {
    return texts.asMap().entries.map((e) {
      return Affirmation(
        id: '${cat.name}_${e.key}',
        text: e.value,
        category: cat,
      );
    }).toList();
  }

  // ─── Public API ───

  List<Affirmation> get allAffirmations => _allAffirmations;

  List<Affirmation> getByCategory(AffirmationCategory category) {
    return _allAffirmations
        .where((a) => a.category == category)
        .toList();
  }

  int getCategoryCount(AffirmationCategory category) {
    return getByCategory(category).length;
  }

  Affirmation? getById(String id) {
    try {
      return _allAffirmations.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Affirmation getDailyAffirmation() {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final savedDate = _storage.getString(StorageService.dailyAffirmationDate);

    if (savedDate == dateStr) {
      final index = _storage.getInt(StorageService.dailyAffirmationIndex) ?? 0;
      return _allAffirmations[index % _allAffirmations.length];
    }

    // New day, pick new affirmation
    final hash = dateStr.hashCode.abs();
    final index = hash % _allAffirmations.length;
    _storage.setString(StorageService.dailyAffirmationDate, dateStr);
    _storage.setInt(StorageService.dailyAffirmationIndex, index);
    return _allAffirmations[index];
  }

  // ─── Favorites ───

  List<String> getFavoriteIds() {
    return _storage.getStringList(StorageService.favoriteIds) ?? [];
  }

  Future<void> toggleFavorite(String id) async {
    final ids = getFavoriteIds();
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    await _storage.setStringList(StorageService.favoriteIds, ids);
  }

  bool isFavorite(String id) {
    return getFavoriteIds().contains(id);
  }

  List<Affirmation> getFavorites() {
    final ids = getFavoriteIds();
    return _allAffirmations
        .where((a) => ids.contains(a.id))
        .map((a) => a.copyWith(isFavorite: true))
        .toList();
  }

  // ─── Daily View Count (Free tier limit) ───

  int getDailyViewCount() {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final savedDate = _storage.getString(StorageService.dailyViewDate);
    if (savedDate != dateStr) {
      _storage.setString(StorageService.dailyViewDate, dateStr);
      _storage.setInt(StorageService.dailyViewCount, 0);
      return 0;
    }
    return _storage.getInt(StorageService.dailyViewCount) ?? 0;
  }

  Future<void> incrementDailyViewCount() async {
    final count = getDailyViewCount();
    await _storage.setInt(StorageService.dailyViewCount, count + 1);
  }
}
