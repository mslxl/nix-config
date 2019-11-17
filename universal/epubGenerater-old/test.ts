import * as puppeteer from 'puppeteer'
import { puppeteerDev } from './puppeteerDevTools';
import { Picture, loadPicture } from './book';

(async()=>{
    const browser = await puppeteer.launch({
        headless: false,
        args: ["--no-sandbox", "--disable-setuid-sandbox"],
    })
    const page = await browser.newPage()
    await page.goto('https://www.baidu.com')
    let src = await page.$eval('#lg > .index-logo-src',i => i.getAttribute('src'))
    let e:Picture = {
        url:src
    }
    await loadPicture(page,e)
    console.log(e.base64)
})()