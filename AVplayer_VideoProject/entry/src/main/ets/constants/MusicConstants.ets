//导入数据接口及类
import {
  FavoriteListType,
  MomentListType,
  RecommendListType,
  RecommendDailyType,
  SongItemType,
  TabClass
} from '../models/Index'

/**
 * TabBar数据
 */
export const tabsData: TabClass[] = [
  {
    title: '推荐',
    name: 'recommend',
    icon: $r('app.media.ic_recommend')
  },
  {
    title: '列表',
    name: 'find',
    icon: $r('app.media.ic_find')
  },
  {
    title: '我的',
    name: 'mine',
    icon: $r('app.media.ic_mine')
  }
]
//轮播图+文字接口
export interface swiperImageText{
  image:ResourceStr
  text:ResourceStr
}
/**
 * 轮播图数据
 */
export const swiperList: swiperImageText[] = [
  {
    image:$r('app.media.pic2'),
    text:'娱乐吃瓜大会10.0启动，来发布娱乐评稿瓜分...'
  },
  {
    image:$r('app.media.pic1'),
    text:'偏爱音乐...'
  },
  {
    image:$r('app.media.pic3'),
    text:'我是帅噶，爱看美女'
  },
  {
    image:$r('app.media.pic4'),
    text:'世界是一个草台班子...'
  },
  {
    image:$r('app.media.pic5'),
    text:'娱乐吃瓜大会10.0启动，来发布娱乐评稿瓜分...'
  },
]

/**
 * 每日推荐数据
 */
export const dailyRecommend: RecommendDailyType[] = [
  {
    img: 'https://maniu.oss-rg-china-mainland.aliyuncs.com/recommend1.png',
    title: '每日推荐 | 今天从《不得不爱》听起 | 私人雷达',
    type: '每日推荐',
    top: '#660000',
    bottom: "#382e2f"
  },
  {
    img: 'https://maniu.oss-rg-china-mainland.aliyuncs.com/recommend2.png',
    title: '从 [Nothing on Me] 开启无限漫游',
    type: '私人漫游',
    top: '#382e2f',
    bottom: "#a37862"
  },
  {
    img: 'https://maniu.oss-rg-china-mainland.aliyuncs.com/recommend3.png',
    title: '每日推荐 | 今天从《不得不爱》听起 | 私人雷达',
    type: '华语流行',
    top: '#a37862',
    bottom: "#174847"
  },
  {
    img: 'https://maniu.oss-rg-china-mainland.aliyuncs.com/recommend4.png',
    title: '每日推荐 | 今天从《不得不爱》听起 | 私人雷达',
    type: '私人雷达',
    top: '#174847',
    bottom: '#174847'
  }
]

/**
 * 推荐歌单数据
 */
export const recommendList: RecommendListType[] = [
  {
    img: 'https://maniu.oss-rg-china-mainland.aliyuncs.com/list1.jpg',
    title: "每日推荐 | 今天从《不得不爱》听起 | 私人雷达",
    count: "270.9万"
  },
  {
    img: 'https://maniu.oss-rg-china-mainland.aliyuncs.com/list2.jpg',
    title: "Yasuo和更多好听的 | 华语私人雷达 | 回忆8090",
    count: "476.1万"
  },
  {
    img: 'https://maniu.oss-rg-china-mainland.aliyuncs.com/list3.jpg',
    title: "Trap Remix丨当欧美热单遇上毒性低音",
    count: "186.3万"
  },
  {
    img: 'https://maniu.oss-rg-china-mainland.aliyuncs.com/list4.jpg',
    title: '满级人类进化之路必备BGM | 根本停不下来',
    count: "186.3万"
  },
  {
    img: 'https://maniu.oss-rg-china-mainland.aliyuncs.com/list5.jpg',
    title: '认真去聆听这个世界的每一分每一秒 (强烈推荐)',
    count: "362.8万"
  }
]
/**
 * 歌曲列表数据 https://elaina-1017-1331423751.cos.ap-guangzhou.myqcloud.com/AVPlayer/1.mp3
 */
export const songs:SongItemType[] = [
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/2.jpg',
    name: '给我一个理由忘记',
    author: 'A-Lin',
    url: 'https://fastcdn.mihoyo.com/content-v2/hk4e/155658/7e4151a1b2c2ca683660557bc1626afb_6480244903198591265.mp4',
    id: '0016'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/1.jpg',
    name: '画',
    author: '赵磊',
    url: 'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/265962461770.mp4',
    id: '0001'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/2.jpg',
    name: 'Sweet Dreams',
    author: 'TPaul Sax / Eurythmics',
    url: 'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/265565920708.mp4',
    id: '0002'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/3.jpg',
    name: '奢香夫人',
    author: '凤凰传奇',
    url: 'https://cloud.video.taobao.com//play/u/2434313402/p/1/e/6/t/1/338090797403.mp4',
    id: '0003'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/4.jpg',
    name: '空心',
    author: '光泽',
    url: 'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/265813827396.mp4',
    id: '0004'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/5.jpg',
    name: '反转地球',
    author: '潘玮柏',
    url: 'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/270530317891.mp4',
    id: '0005'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/6.jpg',
    name: 'No.9',
    author: 'T-ara',
    url: 'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/270529489183.mp4',
    id: '0006'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/7.jpg',
    name: '孤独',
    author: 'G.E.M.邓紫棋',
    url: 'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/285764748670.mp4',
    id: '0007'
  },

  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/8.jpg',
    name: 'Lose Control',
    author: 'Hedley',
    url: 'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/272144266673.mp4',
    id: '0008'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/9.jpg',
    name: '倩女幽魂',
    author: '张国荣',
    url: 'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/272144598132.mp4',
    id: '0009'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/10.jpg',
    name: '北京北京',
    author: '汪峰',
    url: 'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/270295112851.mp4',
    id: '0010'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/11.jpg',
    name: '苦笑',
    author: '汪苏泷',
    url: 'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/270728062810.mp4',
    id: '0011'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/12.jpg',
    name: '一生所爱',
    author: '卢冠廷 / 莫文蔚',
    url: 'https://cloud.video.taobao.com//play/u/2434313402/p/1/e/6/t/1/336168920262.mp4',
    id: '0012'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/13.jpg',
    name: '月半小夜曲',
    author: '李克勤',
    url:'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/266540847164.mp4',
    id: '0013'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/14.jpg',
    name: 'Rolling in the Deep',
    author: 'Adele',
    url: 'https://cloud.video.taobao.com//play/u/2434313402/p/1/e/6/t/1/340907319492.mp4',
    id: '0014'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/15.jpg',
    name: '海阔天空',
    author: 'Beyond',
    url: 'https://cloud.video.taobao.com//play/u/4153493416/p/1/e/6/t/1/265734963795.mp4',
    id: '0015'
  }
]
/**
 * 喜欢列表
 */
export const favoriteList:FavoriteListType = {
  name:'我喜欢的音乐',
  nickName:"稀有歌曲诗人",
  avatar:$r('app.media.ic_favorite'),
  songs:songs
}
