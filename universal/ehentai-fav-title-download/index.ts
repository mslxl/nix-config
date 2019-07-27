import * as puppeteer from 'puppeteer'
import * as fs from 'fs'
import * as request from 'request'
import { url } from 'inspector';

const cookies = '__cfduid=db4ae2bbe982f43bcfe6a977e119a41f01563599707; ipb_member_id=2837655; ipb_pass_hash=c614305d16d7e95de6c33892ab3a68f5; ipb_session_id=bc68dbe0c49f45c33d62fe29c5f2f8b9; sk=kj3kuxxp6us7axjuqdjm511uuhvl'
const pageNum = 44
const favcat = 0
const maxDownload = 4
let curDownload = 0
async function main() {
    let broswer = await puppeteer.launch({
        headless: false,
        args: ["--no-sandbox", "--disable-setuid-sandbox", "--proxy-server=socks5://127.0.0.1:1080"]
    })
    let page = await broswer.newPage()
    let setCookies = cookies.trim()
        .split(';')
        .map(v => {
            let s = v.split('=').map(c => {
                return c.trim()
            })
            let cookie: puppeteer.SetCookie = {
                name: s[0],
                value: s[1],
                domain: 'e-hentai.org'
            }
            return cookie
        })

    await page.setCookie(...setCookies)
    await page.setViewport({ width: 1920, height: 1080 })
    page.on('response', async (res) => {
        // console.log("res.url", res.url(), res.status())
        let url = res.url();
        if (res.status() != 200) {
            await page.reload()
        }
    })
    for (let index = 4; index < pageNum; index++) {
        await pageGoto(page, `https://e-hentai.org/favorites.php?page=${index}&favcat=${favcat}`)
        let selectors = await page.evaluate(() => {
            let num = document.querySelector('.itg > tbody:nth-child(1)').children.length
            let selectors = []
            for (let j = 2; j <= num; j++) {
                selectors.push(`.itg > tbody:nth-child(1) > tr:nth-child(${j})`)
            }
            return selectors
        })
        for (let k = 0; k < selectors.length; k++) {
            let sel = selectors[k]
            const tigger = sel + ' > .gl3c'
            const thumb = sel + ' > .gl2c > .glthumb > div > img'
            await page.hover(tigger)
            let title = await page.$eval(tigger + '> a > .glink', e => {
                return e.textContent
            })
            title = title.replace(/\\/g,'').replace(/\//g,'').replace(/:/g,'').replace(/\*/g,'').replace(/\?/g,'').replace(/</g,'').replace(/>/g,'').replace(/|/g,'')
            await page.waitFor(1000)
            let image_url = await page.$eval(thumb,e=>{
                return e.getAttribute('src')
            })
            let filename = title + '.jpg'

            // Download file
            curDownload++
            let writeStream = fs.createWriteStream(filename);
            let readStream = request(image_url)
            readStream.pipe(writeStream);

            readStream.on('error', function(err) {
                log("错误信息:" + err)
                log(`URL:${url}`)
                log(`Title:${title}`)
                curDownload--
            })
            readStream.on('end', function() {
                console.log(`Download ${url} as ${filename}`)
                curDownload--
            })
            
            while(curDownload >= maxDownload){
                console.log(`Downloading... Status:[${curDownload}/${maxDownload}]`)
                await page.waitFor(10 * 1000)
            }
        }

    }


}

function log(data:any){
    console.log(data)
    fs.appendFileSync('console.log',data)
    fs.appendFileSync('console.log','\n')
}

async function pageGoto(page: puppeteer.Page, link: string) {
    // 反复加载直到成功进入页面
    log('Load ' + link)
    let loadSuccssed = false
    while (!loadSuccssed) {
        await page.goto(link, {
            waitUntil: 'networkidle0',
            timeout: 60 * 1000
        }).catch(() => {
            log('Error! Try to reload')
            loadSuccssed = false
        }).then(() => {
            loadSuccssed = true
        })
    }

}

main()