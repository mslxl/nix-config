import { IWebsite } from "./website";
import { question, repeat } from "../util";
import * as puppeteer from 'puppeteer'
import { url } from "inspector";
import { resolve } from "url";
import { rejects } from "assert";
import { SubTitle, BookInfo, MainBody, Paragraph, Picture, loadPicture } from "../book";
import { puppeteerDev } from "../puppeteerDevTools";

const wait = true

export class Ciweimao implements IWebsite {
    domain: string = "www.ciweimao.com";
    needHeadless: boolean = false
    //　初始化，放置 cookie
    async init(page: puppeteer.Page): Promise<void> {
        let anw = await question("Cookies:")
        if(anw.trim().length > 3){
            let cookies = (anw).split(';').map(e => {
                return e.split('=').map(v => {
                    return v.trim()
                })
            }).map(a => {
                let cookie: puppeteer.SetCookie = {
                    name: a[0],
                    value: a[1],
                    domain: this.domain
                }
                return cookie
            })
            await page.setCookie(...cookies)
        }
    }

    // 获取目录
    catalog(page: puppeteer.Page): Promise<SubTitle[]> {
        return new Promise(async (resolve, rejects) => {
            await page.waitFor('#J_ReadAll')
            await page.click('#J_ReadAll', {
                delay: 120
            })
            let chapters = await page.evaluate(() => {
                let subtitles = []

                let nodes = document.querySelector('.book-chapter-box').children
                for (let i = 0; i < nodes.length; i += 2) {
                    let subTitleN = nodes[i]
                    let chaptersN = nodes[i + 1].children
                    let chapterList = []
                    // 为什么没有 map!!为什么没有 foreach!!为什么连 for in 都不能用!!
                    for (let j = 0; j < chaptersN.length; j++) {
                        const li = chaptersN[j];
                        chapterList.push({
                            title: li.textContent,
                            link: li.firstElementChild.getAttribute('href')
                        })
                    }
                    let st: SubTitle = {
                        title: subTitleN.textContent,
                        chapter: chapterList
                    }
                    subtitles.push(st)
                }
                return subtitles
            })
            resolve(chapters)
        })
    }
    //　获取图书信息
    info(page: puppeteer.Page): Promise<import("../book").BookInfo> {
        return new Promise(async (resolve, rejects) => {
            let info = await page.evaluate(() => {
                let info: BookInfo = {
                    title: document.querySelector('.book-info > .title').firstChild.textContent.trim(),
                    aur: document.querySelector('.book-info > .title').lastChild.textContent.trim(),
                    pic: document.querySelector('.ly-main > .book-hd > .cover > img').getAttribute('src'),
                    desc: document.querySelector('.book-intro-cnt > .book-desc').textContent
                }
                return info
            })
            let realUrl = await puppeteerDev.fillUrl(page,info.pic)
            let base64 = await puppeteerDev.getResourceContent(page,realUrl)
            info.picBase64 = base64
            resolve(info)
        })
    }
    // 取正文（图片或文字）
    text(page: puppeteer.Page, url: string): Promise<MainBody> {
        return new Promise(async (resolve, rejects) => {
            await page.waitFor(2000)
            let mainBody: MainBody = {
                title: 'TODO Wait for page load',
                link: url,
                paragraph: []
            }
            mainBody.title = await page.$eval('#J_BookCnt > .read-hd > .chapter',(e)=>{
                return e.firstChild.textContent
            })
            if (wait) {
                let height = await page.evaluate(() => {
                    return document.body.scrollHeight
                })
                let minTime = height * 100
                let stepN = minTime / height
                let stepL = height / stepN
                for (let i = 0; i < stepN; i++) {
                    await page.evaluate((y: number) => {
                        window.scrollTo(0, y)
                    }, stepL * i)
                    await page.waitFor(200)
                }
            }
            
            if ((await page.$('#J_BookRead')) != null) {
                //不收费章节，文字
                mainBody.paragraph = await page.evaluate(() => {
                    let par: Paragraph[] = []
                    let lines = document.querySelector('#J_BookRead').children

                    for (let i = 0; i < lines.length; i++) {
                        const e = lines[i];
                        let mayImage = e.children[0]
                        if (mayImage.tagName.toLocaleLowerCase() == "img") {
                            par.push({
                                url: mayImage.getAttribute('src')
                            })
                        } else {
                            let t = e.firstChild.textContent
                            console.log("Text" + t)
                            par.push({
                                text: t.trim()
                            })
                        }
                    }
                    return par
                })
                
                //图片加载一遍

                for (let i = 0; i < mainBody.paragraph.length; i++) {
                    const e:any = mainBody.paragraph[i];
                    if(e.url){
                        mainBody.paragraph[i] = await loadPicture(page, e)
                    }
                }


            } else {
                //收费章节，图片
                await page.evaluate(() => {
                    window.scrollTo(0, 30)
                })
                
                page.waitFor('#J_BookImage', { timeout: 60000 }).catch((e) => {})

                let url = await page.evaluate(() => {
                    let el = document.querySelector('#J_BookImage')
                    let cssBG = window.getComputedStyle(el).backgroundImage
                    let reg = /\(['"](.*)['"]\)/
                    return reg.exec(cssBG)[1]
                })
                let pic = {
                    url: url
                }
                mainBody.paragraph.push(await loadPicture(page, pic))
            }
            
            resolve(mainBody)
        })
    }
}
