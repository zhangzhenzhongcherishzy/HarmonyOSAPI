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

/**
 * 轮播图数据
 */
export const swiperList: string[] = [
  "https://maniu.oss-rg-china-mainland.aliyuncs.com/banner1.png",
  "https://maniu.oss-rg-china-mainland.aliyuncs.com/banner2.png",
  "https://maniu.oss-rg-china-mainland.aliyuncs.com/banner3.png",
  "https://maniu.oss-rg-china-mainland.aliyuncs.com/banner4.png",
  "https://maniu.oss-rg-china-mainland.aliyuncs.com/banner5.png"
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
    url: 'https://elaina-1017-1331423751.cos.ap-guangzhou.myqcloud.com/AVPlayer/A-Lin - 给我一个理由忘记 (V0).mp3',
    id: '0016'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/0.jpg',
    name: '直到世界的尽头',
    author: 'WANDS',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/0.m4a',
    id: '0000'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/1.jpg',
    name: '画',
    author: '赵磊',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/1.mp3',
    id: '0001'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/2.jpg',
    name: 'Sweet Dreams',
    author: 'TPaul Sax / Eurythmics',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/2.mp3',
    id: '0002'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/3.jpg',
    name: '奢香夫人',
    author: '凤凰传奇',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/3.m4a',
    id: '0003'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/4.jpg',
    name: '空心',
    author: '光泽',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/4.mp3',
    id: '0004'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/5.jpg',
    name: '反转地球',
    author: '潘玮柏',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/5.mp3',
    id: '0005'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/6.jpg',
    name: 'No.9',
    author: 'T-ara',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/6.m4a',
    id: '0006'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/7.jpg',
    name: '孤独',
    author: 'G.E.M.邓紫棋',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/7.m4a',
    id: '0007'
  },

  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/8.jpg',
    name: 'Lose Control',
    author: 'Hedley',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/8.m4a',
    id: '0008'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/9.jpg',
    name: '倩女幽魂',
    author: '张国荣',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/9.m4a',
    id: '0009'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/10.jpg',
    name: '北京北京',
    author: '汪峰',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/10.m4a',
    id: '0010'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/11.jpg',
    name: '苦笑',
    author: '汪苏泷',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/11.mp3',
    id: '0011'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/12.jpg',
    name: '一生所爱',
    author: '卢冠廷 / 莫文蔚',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/12.m4a',
    id: '0012'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/13.jpg',
    name: '月半小夜曲',
    author: '李克勤',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/13.mp3',
    id: '0013'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/14.jpg',
    name: 'Rolling in the Deep',
    author: 'Adele',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/14.m4a',
    id: '0014'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/15.jpg',
    name: '海阔天空',
    author: 'Beyond',
    url: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/15.m4a',
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
