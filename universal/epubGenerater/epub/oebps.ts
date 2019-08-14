import { Book, MainBody } from "../book";
import * as fs from 'fs'
import * as path from 'path'
import { hashCode } from "../util";
export function writeOebpsContent(oebps: string, info: Book, text: MainBody[]) {

    const mkdir = (dirname: string, block: (dirname: string) => void) => {
        if (!fs.existsSync(dirname)) {
            fs.mkdirSync(dirname)
        }
        block(dirname)
    }

    // <relatepath to OEBPS,data> 
    const fileroute = new Map<string, string>()

    writeStyle(fileroute)
    writeTextPages(fileroute, info, text)
    writeCoverpage(fileroute, info)
    let chapterNum = writeToc(fileroute, info)
    writeContentList(fileroute, info, chapterNum)

    apply(oebps, fileroute)
}

// 递归创建目录 同步方法
function mkdirsSync(dirname: string) {
    if (fs.existsSync(dirname)) {
        return true;
    } else {
        if (mkdirsSync(path.dirname(dirname))) {
            fs.mkdirSync(dirname);
            return true;
        }
    }
}

function apply(oebps: string, fileroute: Map<string, string>) {
    fileroute.forEach((data, key) => {
        let filepath = `${oebps}/${key}`
        let parentDir = path.dirname(filepath)
        if (!fs.existsSync(parentDir)) {
            mkdirsSync(parentDir)
        }
        console.log('Write file: ' + filepath)
        fs.writeFileSync(filepath, data)
    })
}

function filetype(filename: string): string {
    let typelist = new Map<string, string>()
    const t = (casename: string, type: string) => {
        typelist.set(casename, type)
    }

    t('html', 'application/xhtml+xml')
    t('css', 'text/css')
    t('js', 'text/javascript')
    t('jpeg', 'image/jpeg')
    t('png', 'image/png')
    t('jpg', 'image/jpeg')
    t('ncx', 'application/x-dtbncx+xml')

    const casename = filename.substr(filename.lastIndexOf('.') + 1)
    if (typelist.has(casename)) {
        return typelist.get(casename)
    } else {
        return ''
    }
}

function writeContentList(fileroute: Map<string, string>, info: Book, chapterNum: number) {
    const filename = 'content.opf'
    let filelist: string[] = []
    fileroute.forEach((_value, key) => {
        filelist.push(key)
    })
    const data = `<?xml version="1.0" encoding="utf-8" ?>
<package unique-identifier="PrimaryID" version="2.0" xmlns="http://www.idpf.org/2007/opf">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
    <dc:title>${info.info.title}</dc:title>
    <dc:identifier opf:scheme="ISBN"></dc:identifier>
    <dc:language>zh-CN</dc:language>
    <dc:creator opf:role="aut">${info.info.aur}</dc:creator>
    <dc:publisher>epubGenerater</dc:publisher>
    <dc:description>${info.info.desc}</dc:description>
    <dc:coverage></dc:coverage>
    <dc:source>${info.source}</dc:source>
    <dc:date></dc:date>
    <dc:rights></dc:rights>
    <dc:subject></dc:subject>
    <dc:contributor></dc:contributor>
    <dc:type>[type]</dc:type>
    <dc:format></dc:format>
    <dc:relation></dc:relation>
    <dc:builder>epubGenerater</dc:builder>
    <dc:builder_version></dc:builder_version>
    <meta name="cover" content="cover-image"/>
    <meta content="0.9.5" name="Sigil version"/>
    <dc:date opf:event="modification" xmlns:opf="http://www.idpf.org/2007/opf">2018-08-30</dc:date>
  </metadata>
  <manifest>
    ${
        filelist.map((v) => {
            return `
            <item href="${v}" id="${hashCode(v)}"  media-type="${filetype(v)}"/>
            `
        }).reduce((pre, cur) => {
            return pre + cur
        })
        }
        <item href="toc.ncx" id="ncx"  media-type="application/x-dtbncx+xml"/>
    </manifest>
    <spine toc="ncx">
    <itemref idref="coverpage" linear="yes"/>
    ${
        (() => {

            return filelist.filter(v => { return filetype(v) == "application/xhtml+xml" })
                .map(v => `<itemref idref="${hashCode(v)}" linear="yes"/>`)
                .reduce((pre, cur) => pre + cur)

        })()
        }
  </spine>
  <guide>
    <reference href="Text/coverpage.html" title="封面" type="cover"/>
  </guide>
</package>
    `
    fileroute.set(filename, data)
}

function writeToc(fileroute: Map<string, string>, info: Book): number {
    let chapterList: { path: string; title: string; }[] = []
    info.chapterList.forEach(sub => {
        sub.chapter.forEach(chapter => {
            const name = 'Text/' + hashCode(chapter.link) + '.html'
            const title = chapter.title
            chapterList.push({
                path: name,
                title: title
            })
        })
    })
    let playOrder = 0
    const filename = 'toc.ncx'
    const data = `<?xml version="1.0" encoding="utf-8" ?>
    <!DOCTYPE ncx PUBLIC "-//NISO//DTD ncx 2005-1//EN"
                "http://www.daisy.org/z3986/2005/ncx-2005-1.dtd">
    <ncx version="2005-1" xml:lang="en-US" xmlns="http://www.daisy.org/z3986/2005/ncx/">
        <head>
    <!-- The following four metadata items are required for all
        NCX documents, including those conforming to the relaxed
        constraints of OPS 2.0 -->    
        <meta content="51037e82-03ff-11dd-9fbb-0018f369440e" name="dtb:uid"/>
        <meta content="1" name="dtb:depth"/>
        <meta content="0" name="dtb:totalPageCount"/>
        <meta content="0" name="dtb:maxPageNumber"/>
        <meta content="www.cnepub.com" name="provider"/>
        <meta name="builder" content="epubGenerater present by github.com/mslxl/tools/tree/master/universal/epubGenerater"/>
  </head>
  <docTitle>
    <text>${info.info.title}</text>
  </docTitle>
  <docAuthor>
    <text>${info.info.aur}</text>
  </docAuthor>
  <navMap>
    <navPoint id="coverpage" playOrder="0">
        <navLabel>
            <text>封面</text>
        </navLabel>
        <content src="Text/coverpage.html"/>
    </navPoint>
    ${
        info.chapterList.map((v)=>{
            return `<navPoint>
            <navLabel>
                <text>${v.title}</text>
            </navLabel>
            ${
                v.chapter.map(vv=>{
                    return `<navPoint id="${hashCode('Text/'+hashCode(vv.link)+'.html')}" playOrder="${++playOrder}">
                    <navLabel>
                        <text>${vv.title}</text>
                    </navLabel>
                    <content src="${'Text/'+hashCode(vv.link)+'.html'}"/>
                </navPoint>`
                }).reduce((pree,cur) => {
                    return pree + cur
                },"")
            }
        </navPoint>`
        }).reduce((pre,cur) => {
            return pre + cur
        })
    }
  </navMap>
  </ncx>`
    fileroute.set(filename, data)
    return chapterList.length
}
function writeCoverpage(fileroute: Map<string, any>, _info: Book) {

    const filename = 'Text/coverpage.html'
    let bitmap = Buffer.from(_info.info.picBase64, 'base64')
    let path = 'Images/' + hashCode(_info.info.picBase64) + '.png'
    fileroute.set(path,bitmap)

    const data = `<?xml version="1.0" encoding="utf-8"?>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
        "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
        <link rel="stylesheet" type="text/css" href="../Styles/main.css"/>
    <html>
    <div style="text-align:center">
    <div><br/><img class="cover" src="../${path}"/><hr/></div>
    <h1>${_info.info.title}</h1>
    <h2>${_info.info.aur}</h2>
    <p>${_info.info.desc}</p>

    </div>
    </html>`
    fileroute.set(filename, data)
}
function writeStyle(fileroute: Map<string, string>) {
    const filename = 'Styles/main.css'
    const data = `@font-face {
        font-family:"zw";
        src:url(res:///opt/sony/ebook/FONT/zw.ttf),
        url(res:///Data/FONT/zw.ttf),
        url(res:///opt/sony/ebook/FONT/tt0011m_.ttf),
        url(res:///fonts/ttf/zw.ttf),
        url(res:///../../media/mmcblk0p1/fonts/zw.ttf),
        url(res:///DK_System/system/font/zw.ttf),
        url(res:///abook/fonts/zw.ttf),
        url(res:///system/fonts/zw.ttf),
        url(res:///system/media/sdcard/fonts/zw.ttf),
        url(res:///media/fonts/zw.ttf),
        url(res:///sdcard/fonts/zw.ttf),
        url(res:///system/fonts/DroidSansFallback.ttf),
        url(res:///mnt/MOVIFAT/font/zw.ttf),
        url(fonts/zw.ttf);
    }
    
    body {
        padding: 0%;
        margin-top: 0%;
        margin-bottom: 0%;
        margin-left: 1%;
        margin-right: 1%;
        line-height:130%;
        text-align: justify;
        font-family:"zw";
    }
    div {
        margin:0px;
        padding:0px;
        line-height:130%;
        text-align: justify;
        font-family:"zw";
    }
    p {
        text-align: justify;
        text-indent: 2em;
        line-height:130%;
        margin-top: 5pt;
        margin-bottom: 5pt;
    }
    .cover {
        width:100%;
        padding:0px;
    }
    .center {
        text-align: center;
        margin-left: 0%;
        margin-right: 0%;
    }
    .left {
        text-align: left;
        margin-left: 0%;
        margin-right: 0%;
    }
    .right {
        text-align: right;
        margin-left: 0%;
        margin-right: 0%;
    }
    .quote {
        margin-top: 0%;
        margin-bottom: 0%;
        margin-left: 1em;
        margin-right: 1em;
        text-align: justify;
        font-family:"cnepub", serif;
    }
    h1 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:xx-large;
    }
    h2 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:x-large;
    }
    h3 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:large;
    }
    h4 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:medium;
    }
    h5 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:small;
    }
    h6 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:x-small;
    }
    `
    fileroute.set(filename, data)
}

function writeTextPages(fileroute: Map<string, string>, info: Book, text: MainBody[]) {

    let mainBodyMap = new Map<string, MainBody>()
    text.forEach(b => {
        mainBodyMap.set(b.link, b)
    })
    info.chapterList.forEach(subTitle => {
        subTitle.chapter.forEach(chapter => {
            const name = hashCode(chapter.link) + '.html'
            const filename = 'Text/' + name
            console.log(`Building page: ${chapter.title}(${name})`)
            if (!mainBodyMap.has(chapter.link)) {
                console.error(`Can not find ${chapter.title}(${chapter.link})  in local database!`)
            }
            let pageText = mkTextPage(fileroute,mainBodyMap.get(chapter.link))

            fileroute.set(filename, pageText)
        })
    })
}

function mkTextPage(fileroute: Map<string, any>,body: MainBody): string {
    return `<?xml version="1.0" encoding="utf-8"?>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
        "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <meta name="builder" content="epubGenerater present by github.com/mslxl/tools/tree/master/universal/epubGenerater"/>
            <meta name="provider" content="${body.link}"/>
            <link rel="stylesheet" type="text/css" href="../Styles/main.css"/>
            <title>${body.title}</title>
        </head>
        <body>
            <div>
            ${
        body.paragraph.map(p => {
            let pa: any = p
            if (pa.url) {
                let bitmap = Buffer.from(pa.base64, 'base64')
                let path = 'Images/' + hashCode(pa.base64) + '.png'
                fileroute.set(path,bitmap)
                return `<br/><img src="../${path}"/>`


            } else {
                return `<p>${pa.text}</p>`
            }
        }).reduce((pre, cur) => {
            return pre + cur
        })
        }
            </div>
        </body>
    </html>
    `.trim()
}

