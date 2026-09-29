import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ads/ad_ids.dart';

/// 화면 하단에 붙이는 적응형 배너.
///
/// 광고가 로드되기 전에도 **같은 높이의 빈 자리와 하단 SafeArea 여백**을 차지한다.
/// 그래야 광고가 1~2초 뒤 붙을 때 본문이 밀려 올라가지 않고, 로드 전에도 본문이
/// 내비게이션 바에 가리지 않는다. (로드에 실패하면 그때 자리를 접는다.)
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  AdSize? _size;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 콜드 스타트 첫 프레임에는 화면 너비가 0으로 올 수 있다. MediaQuery 에 의존하고
    // 있으므로 너비가 잡히면 이 메서드가 다시 호출된다.
    final width = MediaQuery.sizeOf(context).width.truncate();
    if (_ad == null && width > 0) _load(width);
  }

  Future<void> _load(int width) async {
    // google_mobile_ads 9.x: getCurrentOrientationAnchoredAdaptiveBannerAdSize 는 deprecated
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (size == null || !mounted) return;
    // 광고 요청보다 먼저 크기를 알 수 있으므로, 자리부터 잡아둔다.
    setState(() => _size = size);

    _ad = BannerAd(
      adUnitId: AdIds.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Banner load failed: $err');
          ad.dispose();
          _ad = null;
          if (mounted) setState(() => _size = null);
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    final height = _size?.height.toDouble() ?? 0;
    return SafeArea(
      top: false,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ad == null || !_loaded
            ? null
            : Center(
                child: SizedBox(
                  width: ad.size.width.toDouble(),
                  height: ad.size.height.toDouble(),
                  child: AdWidget(ad: ad),
                ),
              ),
      ),
    );
  }
}
