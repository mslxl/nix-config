import * as puppeteer from 'puppeteer'
import { SubTitle, BookInfo, MainBody } from '../book';

export interface IWebsite{
    domain:string
    needHeadless:boolean
    
    //Set cookies and others
    init(page:puppeteer.Page):Promise<void>

    catalog(page:puppeteer.Page):Promise<SubTitle[]>

    info(page:puppeteer.Page):Promise<BookInfo>

    text(page:puppeteer.Page,url:string): Promise<MainBody>
}
