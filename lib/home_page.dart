import 'package:flutter/material.dart';
import 'package:hot_or_not/service/data_service.dart';
import 'package:hot_or_not/widget/video_player_view.dart';
import 'package:video_player/video_player.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with DataService {
  List<String> videoUrls = [];

  List<VideoPlayerController> videoController = [];

  bool loading = true;

  final PageController _pageController = PageController(initialPage: 0);

  Set<int> initializedIndex = {};

  @override
  void initState() {
    super.initState();

    getVideoUrls().then((value) => setState(() {
          videoUrls.addAll(value);
          videoController = List.generate(
              videoUrls.length,
              (index) =>
                  VideoPlayerController.network(videoUrls.elementAt(index)));
          Future.wait(videoController.sublist(0, 2).map((e) => e.initialize()))
              .then((value) => setState(() {
                    initializedIndex.add(0);
                    initializedIndex.add(1);
                    videoController.elementAt(0).play();
                    videoController.elementAt(0).setLooping(true);
                    loading = false;
                  }));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Visibility(
          visible: !loading,
          replacement: const Center(child: CircularProgressIndicator()),
          child: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              onPageChanged: (page) async {
                videoController.elementAt(page).play();
                videoController.elementAt(page).setLooping(true);

                int nextIndex = (page + 1) % videoUrls.length;

                int prevIndex = (page - 1) % videoUrls.length;

                if (!initializedIndex.contains(nextIndex)) {
                  videoController
                      .elementAt(nextIndex)
                      .initialize()
                      .then((value) => initializedIndex.add(nextIndex));
                } else {
                  videoController
                      .elementAt(prevIndex)
                      .seekTo(const Duration(seconds: 0));
                }

                if (initializedIndex.contains(prevIndex)) {
                  videoController
                      .elementAt(prevIndex)
                      .seekTo(const Duration(seconds: 0));
                }
              },
              itemBuilder: (context, index) {
                bool isPlaying = true;
                double sound = 100;

                return InkWell(
                  onTap: () async {
                    if (isPlaying) {
                      await videoController
                          .elementAt(index % videoUrls.length)
                          .pause();
                      isPlaying = false;
                    } else {
                      await videoController
                          .elementAt(index % videoUrls.length)
                          .play();
                      isPlaying = true;
                    }
                  },
                  child: VideoPlayerView(
                    onMutePressed: () {
                      if (sound == 100) {
                        videoController
                            .elementAt(index % videoUrls.length)
                            .setVolume(0);
                        sound = 0;
                      } else {
                        videoController
                            .elementAt(index % videoUrls.length)
                            .setVolume(100);
                        sound = 100;
                      }
                    },
                    videoUrl: videoUrls.elementAt(index % videoUrls.length),
                    videoController:
                        videoController.elementAt(index % videoUrls.length),
                  ),
                );
              }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
