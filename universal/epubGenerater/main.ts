import * as Url from 'url'
import * as puppeteer from 'puppeteer'
import { IWebsite } from './website/website';
import { Ciweimao } from './website/ciweimao';
import { Book, SubTitle, MainBody } from './book';

import { repeat, hashCode, fsp as fs } from './util';

import { finished } from 'stream';


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

    await fs.write(infoFileName, JSON.stringify(info, null, 4))
    await requestBookText(ws, info, outDir, browser)
    await browser.close()
}

async function requestBookText(ws: IWebsite, info: Book, outDir: string, browser: puppeteer.Browser): Promise<MainBody[]> {
    return new Promise(async (resolve, reject) => {

        const chaptersDir = outDir + "/chapters"
        if (!await fs.exists(chaptersDir)) {
            await fs.mkdir(chaptersDir)
        }

        let bodys: MainBody[] = []
        console.log("request book text...")
        for (let ie = 0; ie < info.chapterList.length; ie++) {
            const e = info.chapterList[ie];
            console.log('process sub ' + e.title + `${ie + 1}/${info.chapterList.length}`)
            for (let iee = 0; iee < e.chapter.length; iee++) {

                const ee = e.chapter[iee];
                let link = ee.link
                console.log('process ' + ee.title + `${iee + 1}/${e.chapter.length}`)

    

                let chapterFile = chaptersDir + `/${hashCode(link)}.json`
                if (await fs.exists(chapterFile)) {
                    try {
                        console.log(`Using cache ${chapterFile} for ${link}`)
                        let b = JSON.parse(await fs.read(chapterFile))
                        bodys.push(b)
                    }catch(e){
                        console.error(e)
                        
                    }
                } else {
                    console.log(`Save ${link} as ${chapterFile}`)
                    let page = await browser.newPage()
                    await page.goto(link)
                    let b = await ws.text(page, link)
                    await fs.write(chapterFile, JSON.stringify(b, null, 4))
                    bodys.push(b)
                    page.close()
                }
            }
        }
        resolve(bodys)
    })
}


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


    if (!(await fs.exists(outDir))) {
        await fs.mkdir(outDir)
    }
    const u = new Url.URL(url)
    if (websites.has(u.hostname)) {
        let ws = websites.get(u.hostname)
        runWS(ws, url, outDir)
    } else {
        console.error(`Unsupported website: ${u.hostname}`)
    }
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