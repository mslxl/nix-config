import * as Url from 'url'
import * as puppeteer from 'puppeteer'
import { IWebsite } from './website/website';
import { Ciweimao } from './website/ciweimao';
import { Book, SubTitle, MainBody } from './book';
import * as fs from 'fs'
import { repeat, hashCode } from './util';

import { generateEpub } from './epub/epub';


const UA = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.108 Safari/537.36"


const websites = new Map<string, IWebsite>()

async function runWS(ws: IWebsite, url: string, outDir: string): Promise<any> {
    const browser = await puppeteer.launch({
        headless: ws.needHeadless,
        args: ["--no-sandbox", "--disable-setuid-sandbox"],
    })
    const page = await browser.newPage()
    page.setUserAgent(UA)

    let info = await generateInfo(page, url, ws)
    const infoFileName = outDir + "/info.json"
    fs.writeFileSync(infoFileName, JSON.stringify(info, null, 4))

    let bodys = await requestBookText(ws, info, outDir, browser)

    browser.close().catch((e)=>{
        console.log(e)
    })
    console.log("Generate epub...")
    generateEpub(info,bodys,outDir)
}

//获取正文
async function requestBookText(ws: IWebsite, info: Book, outDir: string, browser: puppeteer.Browser): Promise<MainBody[]> {
    return new Promise(async (resolve, reject) => {

        const chaptersDir = outDir + "/chapters"
        if (!fs.existsSync(chaptersDir)) {
            fs.mkdirSync(chaptersDir)
        }

        let bodys: MainBody[] = []
        console.log("request book text...")
        for (let ie = 0; ie < info.chapterList.length; ie++) {
            const e = info.chapterList[ie];
            console.log('process sub ' + e.title + `(${ie + 1}/${info.chapterList.length})`)
            for (let iee = 0; iee < e.chapter.length; iee++) {

                const ee = e.chapter[iee];
                let link = ee.link
                console.log('process ' + ee.title + `(${iee + 1}/${e.chapter.length})`)



                let chapterFile = chaptersDir + `/${hashCode(link)}.json`
                if (fs.existsSync(chapterFile)) {
                    try {
                        console.log(`Using cache ${chapterFile} for ${link}`)
                        let b = JSON.parse((fs.readFileSync(chapterFile)).toString())
                        bodys.push(b)
                    } catch (e) {
                        if (e != null) {
                            console.error(e)
                        }
                    }
                } else {
                    console.log(`Save ${link} as ${chapterFile}`)
                    let page = await browser.newPage()

                    // 反复加载直到成功进入页面
                    let loadSuccssed = false
                    while (!loadSuccssed) {
                        await page.goto(link, {
                            waitUntil: 'networkidle0',
                            timeout: 60 * 1000
                        }).catch(()=>{
                            console.log('Timeout! Reload this page!')
                            loadSuccssed = false
                        }).then(()=>{
                            loadSuccssed = true
                        })
                    }

                    let b = await ws.text(page, link)
                    fs.writeFileSync(chapterFile, JSON.stringify(b, null, 4))
                    bodys.push(b)
                    page.close()
                }
            }
        }
        resolve(bodys)
    })
}


//获取图书信息及目录
async function generateInfo(page: puppeteer.Page, url: string, ws: IWebsite): Promise<Book> {
    return new Promise(async (resolve, rejects) => {
        try {
            await ws.init(page)
            await page.goto(url)
            await page.waitFor(2000)

            let info = await ws.info(page)
            let catalog = await ws.catalog(page)
            let book: Book = {
                source: url,
                info: info,
                chapterList: catalog
            }

            resolve(book)
        } catch (e) {
            rejects(e)
        }
    })

}

async function main(url: string, outDir: string) {


    if (!(fs.existsSync(outDir))) {
        fs.mkdirSync(outDir)
    }
    const u = new Url.URL(url)
    if (websites.has(u.hostname)) {
        let ws = websites.get(u.hostname)
        await runWS(ws, url, outDir)
    } else {
        console.error(`Unsupported website: ${u.hostname}`)
    }
    process.exit(0)
}

function initWebsites() {
    const list = [
        new Ciweimao()
    ]
    list.forEach((v) => {
        websites.set(v.domain, v)
    })
}

const args = process.argv.splice(2)
initWebsites()
if (args.length < 2) {
    console.log("args: <book_url> <out_dir>")
    process.exit(-1)
}
main(args[0], args[1])