import { IWebsite } from "./website";
import { question } from "../util";
import * as puppeteer from 'puppeteer'
import { url } from "inspector";
import { resolve } from "url";
import { rejects } from "assert";
import { SubTitle, BookInfo, MainBody, Paragraph } from "../book";
export class Ciweimao implements IWebsite {
    domain: string = "www.ciweimao.com";
    needHeadless: boolean = false
    async init(page: puppeteer.Page): Promise<void> {
        let cookies = (await question("Cookies:")).split(';').map(e => {
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

    async catalog(page: puppeteer.Page): Promise<SubTitle[]> {
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
    async info(page: puppeteer.Page): Promise<import("../book").BookInfo> {
        return new Promise(async (resolve, rejects) => {
            resolve(await page.evaluate(() => {
                let info: BookInfo = {
                    title: document.querySelector('.book-info > .title').firstChild.textContent.trim(),
                    aur: document.querySelector('.book-info > .title').lastChild.textContent.trim(),
                    pic: document.querySelector('.ly-main > .book-hd > .cover > img').getAttribute('src'),
                    desc: document.querySelector('.book-intro-cnt > .book-desc').textContent.split('\n').map(t=>{return t.trim()}).filter(t=>{return (t.length==0||t=="")}).reduce((pre,cur)=>{return (pre+"\n"+cur)})
                }
                return info
            }))
        })
    }

    async text(page:puppeteer.Page,url:string): Promise<MainBody>{
        return new Promise(async (resolve,rejects)=>{
            
            await page.waitFor(1500)
            let mainBoay:MainBody = {
                link:url,
                paragraph:[]
            }
            mainBoay.paragraph = await page.evaluate(()=>{
                let par:Paragraph[] = []
                let lines = document.querySelector('#J_BookRead').children
                for (let i = 0; i < lines.length; i++) {
                    const e = lines[i];
                    let line = e.children[0]
                    if(line.tagName.toLocaleLowerCase() == "img"){
                        par.push({
                            url:line.getAttribute('src')
                        })
                    }else{
                        let t = e.firstChild.textContent
                        par.push({
                            text: t.trim()
                        })
                    }
                }
                return par
            })
            resolve(mainBoay)
        })
    }
}
