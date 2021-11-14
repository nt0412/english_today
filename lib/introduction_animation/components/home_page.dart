

import 'dart:math';
import 'package:Learn_English_Today/feedback_screen.dart';
import 'package:english_words/english_words.dart';
import 'package:Learn_English_Today/models/english_today.dart';
import 'package:Learn_English_Today/packages/quote/qoute_model.dart';
import 'package:Learn_English_Today/packages/quote/quote.dart';
import 'package:Learn_English_Today/pages/all_page.dart';
import 'package:Learn_English_Today/pages/favorites_page.dart';
import 'package:Learn_English_Today/home_screen.dart';
import 'package:Learn_English_Today/pages/control_page.dart';
import 'package:Learn_English_Today/values/app_assets.dart';
import 'package:Learn_English_Today/values/app_colors.dart';
import 'package:Learn_English_Today/values/app_styles.dart';
import 'package:Learn_English_Today/values/share_keys.dart';
import 'package:Learn_English_Today/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Learn_English_Today/pages/profile_page.dart';
import 'package:Learn_English_Today/invite_friend_screen.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];

  String quote = Quotes().getRandom().content!;

  List<int> fixedListRamdom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    print('before await');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('after await');
    int len = prefs.getInt(ShareKeys.counter) ?? 9;
    List<String> newList = [];
    List<int> rans = fixedListRamdom(len: len, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });

    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });

    print('has data');
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(
      noun: noun,
      quote: quote?.content,
      id: quote?.id,
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    getEnglishToday();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF7EBE1),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        title: Text(
          'English today',
          style:
              AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36)),
        
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          
          child: Image.asset(AppAssets.menu),
          
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
                height: size.height * 1 / 10,
                padding: const EdgeInsets.symmetric(horizontal: 54),
                alignment: Alignment.centerLeft,
                child: Text(
                  '"$quote"',
                  style: AppStyles.h5.copyWith(
                    fontSize: 15,
                    color: AppColors.textColor,
                  ),
                )),
            Container(
              height: size.height * 2 / 3,
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: words.length > 5 ? 5 : words.length,
                  itemBuilder: (context, index) {
                    String firstLetter =
                        words[index].noun != null ? words[index].noun! : '';
                    firstLetter = firstLetter.substring(0, 1);

                    String leftLetter =
                        words[index].noun != null ? words[index].noun! : '';
                    leftLetter = leftLetter.substring(1, leftLetter.length);

                    String quoteDefault =
                        "Think of all the beauty still left around you and be happy";

                    String qoute = words[index].quote != null
                        ? words[index].quote!
                        : quoteDefault;

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xffFFCDD2),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(3, 6),
                                blurRadius: 6)
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: index >= 5
                            ? InkWell(
                                onTap: () {
                                  print('show more...');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AllWordsPage(words: words),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text('Show more...',
                                      style: AppStyles.h3.copyWith(shadows: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(3, 6),
                                            blurRadius: 6)
                                      ])),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LikeButton(
                                    onTap: (bool isLiked) async {
                                      setState(() {
                                        words[index].isFavorite =
                                            !words[index].isFavorite;
                                      });
                                      return words[index].isFavorite;
                                    },
                                    isLiked: words[index].isFavorite,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    size: 42,
                                    circleColor: CircleColor(
                                        start: Color(0xff00ddff),
                                        end: Color(0xff0099cc)),
                                    bubblesColor: BubblesColor(
                                      dotPrimaryColor: Color(0xff33b5e5),
                                      dotSecondaryColor: Color(0xff0099cc),
                                    ),
                                    likeBuilder: (bool isLiked) {
                                      return ImageIcon(
                                        AssetImage(AppAssets.heart),
                                        color:
                                            isLiked ? Colors.red : Colors.white,
                                        size: 42,
                                      );
                                    },
                                  ),
                                  // Container(
                                  //     alignment: Alignment.centerRight,
                                  //     child: Image.asset(AppAssets.heart)),
                                  RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                          text: firstLetter,
                                          style: TextStyle(
                                              fontFamily: FontFamily.sen,
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                BoxShadow(
                                                    color: Colors.black38,
                                                    offset: Offset(3, 6),
                                                    blurRadius: 6),
                                              ]),
                                          children: [
                                            TextSpan(
                                                text: leftLetter,
                                                style: TextStyle(
                                                    fontFamily: FontFamily.sen,
                                                    fontSize: 27,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      BoxShadow(
                                                          color: Colors.black38,
                                                          offset: Offset(3, 6),
                                                          blurRadius: 6),
                                                    ])),
                                          ])),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: AutoSizeText(
                                      '"$qoute"',
                                      maxFontSize: 26,
                                      style: AppStyles.h4.copyWith(
                                          letterSpacing: 1,
                                          color: AppColors.textColor),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  }),
            ),

            //indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                height: size.height * 1 / 11,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  alignment: Alignment.center,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 99,
                      itemBuilder: (context, index) {
                        return buildIndicator(index == _currentIndex, size);
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          setState(() {
            getEnglishToday();
          });
        },
        child: Image.asset(AppAssets.exchange),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.red[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 16),
                child: Text(
                  'Menu',
                  style: AppStyles.h3.copyWith(color: AppColors.textColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                    label: 'List words',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AllWordsPage(words: words)));
                    }),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 24),
              //   child: AppButton(
              //       label: 'Favorites',
              //     onTap: () {
              //         Navigator.push(context,
              //             MaterialPageRoute(builder: (_) => ControlPage()));
              //       }),
              // ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                    label: 'Adjust word count',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ControlPage()));
                    }),
              ),
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                    label: 'Invite friends',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => InviteFriend()));
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                    label: 'Feedback',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => FeedbackScreen()));
                    }),
              ),
              
              Padding(
                 padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                    label: 'Author',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ProfilePage()));
                    }),
              ),
           
              Padding(
                 padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                    label: 'dashboard',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    }),
              ),
           
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
          color: isActive ? AppColors.lighBlue : AppColors.lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }
}
