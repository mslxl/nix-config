import * as puppeteer from 'puppeteer'
import * as assert from 'assert'

export module puppeteerDev {
    export async function getResourceTree(p: puppeteer.Page): Promise<any> {
        let page: any = p
        var resource = await page._client.send('Page.getResourceTree')
        console.log(JSON.stringify(resource))
        return resource.frameTree;
    }

    export async function getResourceContent(p: puppeteer.Page, url: string): Promise<string> {
        let page: any = p
        const { content, base64Encoded } = await page._client.send(
            'Page.getResourceContent',
            { frameId: String(page.mainFrame()._id), url },
        );
        assert.equal(base64Encoded, true);
        return content;
    }

    export async function fillUrl(p: puppeteer.Page, url: string): Promise<string> {
        return p.evaluate((url: string) => {
            let fill: (u: string) => string = function (u: string) {
                u = u.toString()
                if (u.startsWith('//')) {
                    //补全协议名
                    return window.location.protocol + u
                } else if (u.startsWith('/')) {
                    //补全域名继续
                    return fill(`//${window.location.host}${u}`)
                } else {
                    if (u.startsWith('https:') || u.startsWith('http:')) {
                        //无需补全
                        return u
                    } else {
                        //补全路径名继续
                        return fill(window.location.pathname.substr(0, window.location.pathname.lastIndexOf('/') + 1) + u)
                    }
                }
            }
            return fill(url)
        }, url)
    }
}
