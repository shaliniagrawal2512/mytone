import 'package:mytone/components/EmptyScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:http/http.dart';
import 'package:mytone/constants.dart';

List items = [];
List globalItems = [];
bool fetched = false;

class TopCharts extends StatefulWidget {
  @override
  _TopChartsState createState() => _TopChartsState();
}

class _TopChartsState extends State<TopCharts> {
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          leading: null,
          leadingWidth: 0,
          backgroundColor: kBackgroundColor,
          title: TabBar(
            indicatorColor: Color(0xFF7E1CEA),
            tabs: [
              Tab(text: 'Local'),
              Tab(text: 'Global'),
            ],
          ),
        ),
        body: TabBarView(children: [
          TopPage(
            region: 'In',
          ),
          const TopPage(
            region: 'global',
          ),
        ]),
      ),
    );
  }
}

Future<List> scrapData(String region) async {
  final HtmlUnescape unescape = HtmlUnescape();
  const String url = 'www.spotifycharts.com';
  final String path = '/regional/$region/daily/latest/';
  final Response res = await get(Uri.https(url, path));

  if (res.statusCode != 200) return List.empty();
  final List result = RegExp(
          r'\<td class=\"chart-table-image\"\>\n[ ]*?\<a href=\"https:\/\/open\.spotify\.com\/track\/(.*?)\" target=\"_blank\"\>\n[ ]*?\<img src=\"(https:\/\/i\.scdn\.co\/image\/.*?)\"\>\n[ ]*?\<\/a\>\n[ ]*?<\/td\>\n[ ]*?<td class=\"chart-table-position\">([0-9]*?)<\/td>\n[ ]*?<td class=\"chart-table-trend\">[.|\n| ]*<.*\n[ ]*<.*\n[ ]*<.*\n[ ]*<.*\n[ ]*<td class=\"chart-table-track\">\n[ ]*?<strong>(.*?)<\/strong>\n[ ]*?<span>by (.*?)<\/span>\n[ ]*?<\/td>\n[ ]*?<td class="chart-table-streams">(.*?)<\/td>')
      .allMatches(res.body)
      .map((m) {
    return {
      'id': m[1],
      'image': m[2],
      'position': m[3],
      'title': unescape.convert(m[4]!),
      'album': '',
      'artist': unescape.convert(m[5]!),
      'streams': m[6],
      'region': region,
    };
  }).toList();
  return result;
}

class TopPage extends StatefulWidget {
  final String region;
  const TopPage({required this.region});
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage>
    with AutomaticKeepAliveClientMixin<TopPage> {
  Future<void> getData(String region) async {
    final List temp = await scrapData('in');
    final List temp2 = await scrapData('global');
    globalItems = temp2;
    items = temp;
    fetched = true;
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (globalItems.isEmpty) {
      getData('global');
    } else {
      if (items.isEmpty) {
        getData(widget.region);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!fetched) {
      getData(widget.region);
    }
    List showList = widget.region == 'global' ? globalItems : items;
    return Column(
      children: [
        showList.length <= 10
            ? Expanded(
                child: fetched
                    ? EmptyScreen().emptyScreen(context, 0, ':( ', 100, 'ERROR',
                        60, 'Service Unavailable', 20)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.width / 7,
                              width: MediaQuery.of(context).size.width / 7,
                              child: const CircularProgressIndicator()),
                        ],
                      ),
              )
            : Expanded(
                child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: showList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            const Image(
                              image: AssetImage('images/cover.jpg'),
                            ),
                            if (showList[index]['image'] != '')
                              CachedNetworkImage(
                                imageUrl: showList[index]['image'].toString(),
                                errorWidget: (context, _, __) => const Image(
                                  image: AssetImage('images/cover.jpg'),
                                ),
                                placeholder: (context, url) => const Image(
                                  image: AssetImage('images/cover.jpg'),
                                ),
                              ),
                          ],
                        ),
                      ),
                      title: Text(
                        showList[index]['position'] == null
                            ? '${showList[index]["title"]}'
                            : '${showList[index]['position']}. ${showList[index]["title"]}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${showList[index]['artist']}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {},
                    );
                  },
                ),
              )),
      ],
    );
  }
}
