export interface Book{
    source:string,
    info:BookInfo
    chapterList:SubTitle[]
}

export interface BookInfo{
    title:string,
    aur:string,
    desc:string,
    pic?:string,
    picBase64?:string
}

export interface SubTitle{
    title?:string
    chapter:Chapter[]
}

export interface Chapter{
    title:string
    link:string
}

export interface MainBody{
    title:string
    link:string
    paragraph:Paragraph[]
}

export interface Paragraph{

}

export interface Text extends Paragraph{
    text:string
}

export interface Picture extends Paragraph{
    url:string,
    base64?:string
}

import * as puppeteer from 'puppeteer'
import { puppeteerDev } from './puppeteerDevTools';
export async function loadPicture(p:puppeteer.Page,pic:Picture): Promise<Picture>{
    let url = await puppeteerDev.fillUrl(p,pic.url)
    console.log("Image URL: "+url)
    pic.base64 = await puppeteerDev.getResourceContent(p,url)
    return pic
}