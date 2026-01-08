const config = {
	//网页元数据
	metaData: {
		title: 'TangShiMei的个人主页🎉',
		description: '欢迎来到TangShiMei的秘密基地！',
		keywords: 'TangShiMei,TangShiMei,个人主页,个人网站',
		icon: '/img/favicon.ico'   //网页图标，支持外链
	},

	avatar: "/img/avatar02.jpg", // 头像
	welcometitle: "Hi, I'm TangShiMei", // 标题

    // 👇 新增：网站实际上线时间（ISO 8601 格式）
    launchTime: "2025-12-07T00:00:00", // ← 请根据实际情况修改此时间！


	// 颜色配置
	color: {
		themecolor: "#FFFFFF", // 主题颜色，推荐趋于亮白可带有轻微色调，例： #D1FFEC
		welcometitlecolor: "#FFFFFF", // 标题颜色 例： #7BFFC9
		turntablecolor1: "#FFFF00",  // 转盘渐变色一
		turntablecolor2: "#00FFFF"   // 转盘渐变色二
	},

	brightness: 85, // 背景亮度 --%
	blur: 5, // 毛玻璃模糊效果

	// 我的标签
	tags: ['乐观开朗', '温柔体贴', '随和亲切', '冷静沉着', '才思敏捷', '风趣幽默', '刚正不阿', '善解人意'],

	// 默认背景壁纸
	background: {
		"pc": {   //pc端
			"type": "pic",   //"pic":静态壁纸;"video":动态壁纸
			"datainfo": {
				"title": "海洋女孩",
				"preview": "/img/wallpaper/static/夏末叶栖：银发少女的侧影.jpg",
				"url": "/img/wallpaper/static/夏末叶栖：银发少女的侧影.jpg",     //当然，也可填写网络地址或壁纸api，如随机PC壁纸api："url":"https://t.mwm.moe/pc"
			},
		},
		"mobile": {   //移动端
			"type": "pic",
			"datainfo": {
				"title": "0001",
				"preview": "/img/wallpaper/static-mobile/0001/IMG_12798.webp",
				"url": "/img/wallpaper/static-mobile/0001/IMG_12798.webp"  //同理，随机移动端壁纸："url":"https://t.mwm.moe/mp"
			}
		}

	},

	//极坐标图数据
	polarChart: {
		skills: ['外向性', '责任心', '开放性', '情绪稳定', '团队协作', '时间管理', '自学能力', '内向'],
		skillPoints: [50, 90, 60, 78, 80, 87, 85, 65, 82, 80, 99],
	},

	//社交按钮
	socialPlatformIcons: [
		{ icon: "mdi-github", link: "https://www.github.com/TangShiMei02" },
		{ icon: "mdi-email", link: "mailto:yangqinhao1101@163.com" },
		{ icon: "mdi-qqchat", link: "https://res.abeim.cn/api/qq/?qq=2244182951" },
		{ icon: "mdi-wechat", link: "https://wx.qq.com/" },
		{ icon: "mdi-television-play", link: "https://space.bilibili.com/675768777" },
		{ icon: "mdi-youtube", link: "https://www.youtube.com" },
		{ icon: "mdi-send-variant", link: "https://space.bilibili.com/675768777" }
	],

	//打字机
	typeWriterStrings: [
		"如果你看到了这行字，说明我已经成功吸引到了你的注意力。",
		//"顶峰的少年，给了你所有细节，你却说我不是迪迦，给不了你想要的光。",
		//"心简单，世界就简单，幸福才会生长；心自由，生活就自由，到哪都有快乐。",
		//"生命太短，没有时间留给遗憾，若不是终点，请微笑一直向前。",
		"正在用网页端浏览的小伙伴们注意下左下角的小齿轮可以探索下哦！！",
		"撒谎是人的本性，在大多数时间里我们甚至都不能对自己诚实。——《罗生门》",
		"城南小陌又逢春，只见梅花不见人。离别总是难免，我们终要和握不住的东西说再见。",
		"原来这世上真的存在来不及，来不及好好说话，来不及好好道别，当我终于开始痛哭的时候，一切都回不去了。",
		"也许世界上有5000多与你一模一样的花，但只有你是我独一无二的玫瑰。如果你下午四点来，那从下午三点钟起，我就开始感到幸福。",
		"爷爷的离去不是一场暴雨，而是贯穿我一生的潮湿，我永远困在这潮湿中，在每一个波澜不惊的日子里，掀起狂风暴雨。———— 《第七天》",
		"人最怕的是相遇，最难的是别离，因为一场邂逅就是翻山越岭的回忆。故事的开头总是这样，适逢其会， 猝不及防；故事的结尾总是这样花开两朵， 天各一方。 ———— 《从你的全世界路过》"
	],

	//音乐播放配置，采用MetingJS Api(https://github.com/metowolf/MetingJS)
	musicPlayer: {
		server: 'netease',  //服务提供商 --网易云音乐
		type: 'playlist',   //歌单类型
		id: '2028178887'  //歌单id ---> music.163.com/#/playlist?id=2028178887
	},

	//壁纸数据 -----可以将壁纸文件上传到图床获取网络直链。若想调用api，请前往脚本自行修改逻辑
	wallpaper: {
		pic: [
			{ "title": "海洋女孩", "preview": "/img/wallpaper/static/海洋女孩/image-pre.webp", "url": "/img/wallpaper/static/海洋女孩/image.png" },
			{ "title": "书房夜晚", "preview": "/img/wallpaper/static/书房夜晚/image-pre.webp", "url": "/img/wallpaper/static/书房夜晚/image.png" },
			{ "title": "安逸舒适", "preview": "/img/wallpaper/static/安逸舒适/image-pre.webp", "url": "/img/wallpaper/static/安逸舒适/image.png" },
			{ "title": "清夏银飔", "preview": "https://cdn.magicalapk.com/square/efcd788c-20c2-4cf1-acfb-5902915d2abd.jpg", "url": "https://cdn.magicalapk.com/square/efcd788c-20c2-4cf1-acfb-5902915d2abd.jpg" },
			{ "title": "jswcMaMj", "preview": "https://s21.ax1x.com/2025/07/23/pVGli59.md.jpg", "url": "https://s21.ax1x.com/2025/07/23/pVGli59.jpg" },
			{ "title": "pgtTqoqq", "preview": "https://s21.ax1x.com/2025/07/23/pVGlmDO.md.jpg", "url": "https://s21.ax1x.com/2025/07/23/pVGlmDO.jpg" },
			{ "title": "cvKMKhue", "preview": "https://s21.ax1x.com/2025/07/23/pVGlNqS.md.jpg", "url": "https://s21.ax1x.com/2025/07/23/pVGlNqS.jpg" },
			{ "title": "XpxvQVoP", "preview": "https://s21.ax1x.com/2025/07/23/pVGlfIJ.md.jpg", "url": "https://s21.ax1x.com/2025/07/23/pVGlfIJ.jpg" },
			{ "title": "fVEEjEOA", "preview": "https://s21.ax1x.com/2025/07/23/pVGlEgx.md.webp", "url": "https://s21.ax1x.com/2025/07/23/pVGlEgx.webp" },
			{ "title": "jgnIKMpd", "preview": "https://s21.ax1x.com/2025/07/23/pVGldaQ.md.jpg", "url": "https://s21.ax1x.com/2025/07/23/pVGldaQ.jpg" },
			{ "title": "mgqyySeh", "preview": "https://s21.ax1x.com/2025/07/23/pVGl82t.md.jpg", "url": "https://s21.ax1x.com/2025/07/23/pVGl82t.jpg" },
			{ "title": "dSXZfZp", "preview": "https://s21.ax1x.com/2025/07/23/pVGlaVg.md.jpg", "url": "https://s21.ax1x.com/2025/07/23/pVGlaVg.jpg" },
		],
		picMobile: [
			{ "title": "0001", "preview": "/img/wallpaper/static-mobile/0001/image-pre.webp", "url": "/img/wallpaper/static-mobile/0001/image.png" },
			{ "title": "0002", "preview": "/img/wallpaper/static-mobile/0002/image-pre.webp", "url": "/img/wallpaper/static-mobile/0002/image.png" },
			{ "title": "0003", "preview": "/img/wallpaper/static-mobile/0003/image-pre.webp", "url": "/img/wallpaper/static-mobile/0003/image.png" },
			{ "title": "0004", "preview": "/img/wallpaper/static-mobile/0004/image-pre.webp", "url": "/img/wallpaper/static-mobile/0004/image.png" },
			{ "title": "DfNHPPcc", "preview": "https://s21.ax1x.com/2025/07/23/pVG1uQ0.md.jpg", "url": "https://s21.ax1x.com/2025/07/23/pVG1uQ0.jpg" },
			{ "title": "cZZwzhis", "preview": "https://s21.ax1x.com/2025/07/23/pVG1Vij.md.jpg", "url": "https://s21.ax1x.com/2025/07/23/pVG1Vij.jpg" },
			{ "title": "aANKZHPX", "preview": "https://s21.ax1x.com/2025/07/23/pVGlIR1.md.jpg", "url": "https://s21.ax1x.com/2025/07/23/pVGlIR1.jpg" },
		],
		video: [
			{
				"title": "尼尔：机械纪元 团队",
				"preview": "/img/wallpaper/dynamic/尼尔：机械纪元 团队/Nier-Automata-Team-pre.webm",
				"url": "/img/wallpaper/dynamic/尼尔：机械纪元 团队/Nier-Automata-Team.webm"
			},
			{
				"title": "向往航天的女孩",
				"preview": "/img/wallpaper/dynamic/向往航天的女孩/Toy-Aeroplane-pre.webm",
				"url": "/img/wallpaper/dynamic/向往航天的女孩/Toy-Aeroplane.webm"
			},
			{
				"title": "世界很温柔《龙族》上杉绘梨衣",
				"preview": "https://www.leleo.top/img/wallpaper/dynamic/%E4%B8%96%E7%95%8C%E5%BE%88%E6%B8%A9%E6%9F%94%E3%80%8A%E9%BE%99%E6%97%8F%E3%80%8B%E4%B8%8A%E6%9D%89%E7%BB%98%E6%A2%A8%E8%A1%A3/A2EF5E85-pre.webm",
				"url": "https://www.leleo.top/img/wallpaper/dynamic/%E4%B8%96%E7%95%8C%E5%BE%88%E6%B8%A9%E6%9F%94%E3%80%8A%E9%BE%99%E6%97%8F%E3%80%8B%E4%B8%8A%E6%9D%89%E7%BB%98%E6%A2%A8%E8%A1%A3/A2EF5E85.webm"
			},

		],
		videoMobile: [
			{
				"title": "幻觉镇-gaako_illust",
				"preview": "/img/wallpaper/dynamic-mobile/幻觉镇-gaako_illust/Hallucination_town-pre.mp4",
				"url": "/img/wallpaper/dynamic-mobile/幻觉镇-gaako_illust/Hallucination_town.mp4"
			},
			{
				"title": "chuva",
				"preview": "/img/wallpaper/dynamic-mobile/chuva/chuva-pre.mp4",
				"url": "/img/wallpaper/dynamic-mobile/chuva/chuva.mp4"
			},
			{
				"title": "Doodle-小猫女仆降临",
				"preview": "/img/wallpaper/dynamic-mobile/Doodle-小猫女仆降临/d12-pre.mp4",
				"url": "/img/wallpaper/dynamic-mobile/Doodle-小猫女仆降临/d12.mp4"
			},
		],
	},

	//项目卡片 其中 字段"show"控制初始卡片的text是否展开
	projectcards: [
		{ go: "🔍 前往", img: "/img/蓝发垂落时，星空照城市.png", title: "博客", subtitle: "这里是我的小空间，欢迎点进来支持一下啊", text: "2025年12月26日晚上22点18分写", url: " https://tang-blog.leleosd.top/  ", show: false },
		{ go: "🚀 前往", img: "/img/project-img/IMG_4532.webp", title: "留言板", subtitle: "欢迎留言啊！", text: "想说啥就说，别不说，中不中？真diss！！", url: "https://tang-blog.leleosd.top/comments/", show: false },     //  👉  /deployed-projects/leave-a-message.html  👈 这个是本地的一个留言页面，回来前面那个url不能用了就先用这个
		{ go: "📝 前往", img: "/img/project-img/1755067466457.jpg", title: "本站数据报", subtitle: "用的是51.la统计，还是太好用啦，哈哈哈！", text: "不要再点错啦！点前往哦", url: "https://v6.51.la/s/4e15gMExaC7sDLm", show: false },
		{ go: "🗂️ 前往", img: "/img/project-img/1754876989101.jpeg", title: "我的旧秘密基地", subtitle: "点击下面这个前往我那个不成熟，稚嫩的秘密基地", text: "点错啦，是左边那个 🗂️前往 按钮哦！！", url: "https://tangshimei.leleosd.top/", show: false },
		{ go: "👍 前往", img: "https://pic.tsmei.lilys.top/file/本图床网站相关图片/1767769652994_image.png", title: "一个自建的图床", subtitle: "cloudflare＋纸飞机实现的", text: "点击那个前往按钮啦，可以尝试一下哦！！20260107 1613", url: "https://pic-tsmei.leleosd.top/", show: false },
		{ go: "🗃 前往", img: "/img/project-img/1755074935144.webp", title: "Project 5", subtitle: "5,000 miles of wonder", text: "If you see this line, I've managed to get your attention.", url: "https://tang-blog.leleosd.top/", show: false },
		{ go: "🎨 前往", img: "/img/sunshine.jpg", title: "Project 6", subtitle: "6,000 miles of wonder", text: "If you see this line, I've managed to get your attention.", url: "https://tang-blog.leleosd.top/", show: false },
		{ go: "💍 前往", img: "/img/sunshine.jpg", title: "Project 7", subtitle: "7,000 miles of wonder", text: "If you see this line, I've managed to get your attention.", url: "https://tang-blog.leleosd.top/", show: false },	
	],

	statement: ["Copyright © 2025 TangShiMei"],
}

export default config